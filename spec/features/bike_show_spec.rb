require 'spec_helper'

describe "Showing a bike", :type => :feature do
  context "with an available hook and assignment" do
    let(:program){FactoryGirl.create(:program)}
    let(:hook){FactoryGirl.create(:hook)}

    before :each do
      program
      hook
    end
    
    context "that is new" do
      let(:bike){FactoryGirl.create(:bike)}
      before :each do
        visit bike_path(bike)
      end
      
      it "lists the bike number" do
        expect(page).to have_text bike.number
      end
      
      it "has a form to reserve a hook" do
        expect(page).to have_button I18n.translate('commit_btn.new_hook_reservation')
      end

      describe "reserving an available hook" do
        let(:hook){FactoryGirl.create(:hook)}
        before :each do
          hook
          visit bike_path(bike)
          select hook.number, :from => :hook_id              
          click_button I18n.translate('commit_btn.new_hook_reservation')
          bike.reload
        end        
        
        it "assigns the hook to the bike" do
          expect(bike.hook).to_not be_nil
        end
      end # describe "reserving an available hook"

      describe "reserving an available hook" do        
        let(:hook){FactoryGirl.create(:hook)}
        context "when no hook is specified" do
          before :each do
            hook
            visit bike_path(bike)
            click_button I18n.translate('commit_btn.new_hook_reservation')
            bike.reload
          end        
          
          it "does not assign a hook to the bike" do
            expect(bike.hook).to be_nil
          end

          it "does not depart the bike" do
            expect(bike).to_not be_departed
          end
        end # context "when no hook is specified"
      end # describe "reserving the hook"

      describe "being assigned to a program" do
        let(:program){FactoryGirl.create(:program)}

        before :each do
          visit bike_path(bike)
          select program.label, :from => :program_id
          click_button I18n.translate('commit_btn.new_assignment')
        end

        it "makes the bike unavailable" do
          expect(bike).to_not be_available
        end

        it "assigns the bike to the program" do
          expect(bike.application).to eq program
        end
      end # describe "being assigned to a program"

      describe "being departed" do
        context "without an assignment" do
          before :each do
            visit bike_path bike
          end

          it "can specify destination" do
            expect(page).to have_select :destination_id
          end
          
          context "without speficifying destination" do
            before :each do
              visit bike_path bike
              click_button I18n.translate('commit_btn.new_departure')
            end

            it "does not depart the bike" do
              expect(bike).to_not be_departed
            end

            it "does not assign the bike" do
              expect(bike.application).to be_nil
            end
          end # context "without speficifying destination"

          context "with specifying destination" do
            let(:destination){FactoryGirl.create(:destination)}
            before :each do
              destination #make sure it is created before visiting the page
              visit bike_path bike
              select destination.label, :from => :destination_id              
              click_button I18n.translate('commit_btn.new_departure')
            end

            it "departs the bike" do
              expect(bike).to be_departed
            end

            it "assigns the bike to the destination" do
              expect(bike.application).to_not be_nil
              expect(bike.application.method).to eq destination
            end
          end # context "with specifying destination"

        end

        context "with an assignment" do
          let (:assignment){FactoryGirl.create(:assignment)}
          subject(:assigned_bike){assignment.bike}

          before :each do
            visit bike_path assigned_bike
            click_button I18n.translate('commit_btn.new_departure')
          end
        end # context "with an assignment"
      end # describe "being departed"


    end #  context "that is new"
    
    context "with a hook" do
      let(:reservation){FactoryGirl.create(:hook_reservation)}
      let(:bike){reservation.bike}
      before :each do
        visit bike_path(bike)
      end
      
      it "lists the bike number" do
        expect(page).to have_text bike.number
      end

      it "has a form to free the hook" do
        expect(page).to have_button I18n.translate('commit_btn.delete_hook_reservation')
      end

      describe "freeing the hook" do
        before :each do
          visit bike_path(bike)
          click_button I18n.translate('commit_btn.delete_hook_reservation')
          bike.reload
        end
        it "removes the hook from the bike" do
          expect(bike.hook).to be_nil
        end
      end
    end #  context "with a hook"
    
    context "not departed with an assigned program" do
      let(:assignment){FactoryGirl.create(:assignment)}
      let(:bike){assignment.bike}
      before :each do
        visit bike_path(bike)
      end
      
      it "lists the bike number" do
        expect(page).to have_text bike.number
      end
    end # context "not departed with an assigned program"
    
    context "when departed with assigned program" do
      let(:assignment){FactoryGirl.create(:assignment_departed_prog)}
      let(:bike){assignment.bike}
      before :each do
        visit bike_path(bike)
      end
      
      it "lists the bike number" do
        expect(page).to have_text bike.number
      end
    end # context "when departed with assigned program"

    context "when departed with assigned destination" do
      let(:assignment){FactoryGirl.create(:assignment_departed_dest)}
      let(:bike){assignment.bike}
      before :each do
        visit bike_path(bike)
      end
      it "lists the bike number" do
        expect(page).to have_text bike.number
      end
    end # context "when departed with assigned destination"
  end # context "with an available hook and program defined"
end
