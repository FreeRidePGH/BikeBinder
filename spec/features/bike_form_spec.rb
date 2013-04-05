require 'spec_helper'

describe "The bike form", :type => :feature do
  let(:sig){"ABC"}
  let(:user){FactoryGirl.create(:user)}

  before :each do
    visit new_user_session_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    click_button 'commit'
  end

  context "for a new bike" do
    it "has required inputs" do
      visit new_bike_path
      expect(page).to have_content "Color"
      expect(page).to have_content "Number"
    end

    describe "submitting a blank form" do
      before :each do
        visit new_bike_path
        fill_in "sig", :with => sig
        click_button 'commit' #I18n.translate('commit_btn')[:new]
      end

      it "indicates errors" do
        expect(page).to_not have_text I18n.translate('controller.bikes.create.success')
        expect(page).to have_text "Errors"
      end
    end

    context "with valid params" do
      let(:bike_number){FactoryGirl.generate(:bike_number)}
      let(:color){ColorNameI18n::Color.new(Settings::Color.options.first)}

      before :each do
        visit new_bike_path
        fill_in 'Number', :with => bike_number
        select color.name.capitalize, :from => 'Color'
        fill_in "sig", :with => sig
        click_button 'commit' #I18n.translate('commit_btn')[:new]
      end

      it "indicates success" do
        expect(page).to have_text I18n.translate('controller.bikes.create.success')
      end

      it "shows the bike number" do
        expect(page).to have_content bike_number
      end
    end #  context "with valid params"
  end

  describe "brand and model use case" do

    # Different use cases for editing the brand and model
    # 
    # * User finds the model they want
    # * User finds the brand they want, but creates the model
    # * User creates a brand and model
    # * User knows model but not the brand
    #  * There is a model that already exists for this case
    #  * There is no existing model for this case
    # * User knows the brand but not the model
    #  * The brand already exists
    #  * The brand does not exist
    
    describe "selecting a model" do
      context "while editing a new bike" do      
        let(:model){FactoryGirl.create(:bike_model)}
        
        before :each do
          model
          visit new_bike_path
        end

        it "has a select2 selection", :js => true do
          within "#s2id_bike_form_bike_model_id" do
            expect(first('a').click).to_not be_nil
          end
        end

        it "creates and assigns the model that is selected", :js => true do
          css_drop = Select2BikeBinder::Builder::ModelNestedBrandSelect::Selector[]
          within "#s2id_bike_form_bike_model_id" do
            expect(first('a').click).to_not be_nil
          end
          first("div.#{css_drop} div.select2-search input").set model.name+"\r\n"          
          sleep(1.5)
          #save_screenshot(File.join(SPEC_TEMP_PATH, 'screen0.png'), :full => true)
          first("div.#{css_drop} ul.select2-results li ul li").click
          sleep(0.25)
          #save_screenshot(File.join(SPEC_TEMP_PATH, 'screen1.png'), :full => true)
          fill_in "sig", :with => sig
          first('#commit').click
          expect(page).to have_content model.name
          expect(BikeModel.where(:name => model.name).first).to_not be_nil
        end

      end # context "while editing a new bike"
    end # describe "selecting a model"
    
    describe "creating the brand and model" do
      context "while editing an existing bike" do
        let(:new_model_name){FactoryGirl.generate(:bike_model_name)}
        let(:new_brand_name){FactoryGirl.generate(:bike_brand_name)}
        let(:bike){FactoryGirl.create(:bike)}

        before :each do
          visit edit_bike_path(bike)
          page.choose('bike_form_brand_action_create')
          fill_in 'Brand', :with => new_brand_name
          fill_in 'Model', :with => new_model_name
          fill_in "sig", :with => sig
          click_button 'commit'
          bike.reload
        end

        it "should create and assign the model with correct model name and brand name" do
          expect(bike.model.name).to eq(new_model_name)
          expect(page).to have_content new_brand_name
          expect(page).to have_content new_model_name
        end

      end # context "for editing an existing bike" do
      
      context "for creating a new bike" do
      end # context "for creating a new bike" do

    end #  describe "editing the brand and model" do

  end #   describe "bike brand and model use case"

end # describe "The bike form", :type => :feature do
