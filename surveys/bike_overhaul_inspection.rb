survey "Bike Overhaul Inspection" do
  section "Checklist" do
    # In a quiz, both the questions and the answers need to have reference identifiers
    # Here, the question has reference_identifier: "1", and the answers: "oint", "tweet", and "moo"
    #question_1 "What is the best meat?", :pick => :one, :correct => "oink"
    #a_oink "bacon"
    #a_tweet "chicken"
    #a_moo "beef"

    grid "Are bearings adjusted?" do
      a_y "Yes"
      a_n "No"

      q "Bottom bracket is adjusted properly", :pick => :one, :correct => "y"
      q "Headset is adjusted properly", :pick => :one, :correct => "y"
    end

    grid "Wheels are repaired?" do
      a_y "Yes"
      a_n "No"
      
      q "Front wheel is true", :pick => :one, :correct => "y"
      q "Rear wheel is true", :pick => :one, :correct => "y"
      q "Tires have appropriate pressure?", :pick => :one, :correct => "y"
    end

    grid "Brakes are working" do
      a_y "Yes"
      a_n "No"
      
      q "Brake pads parallel to rim", :pick => :one, :correct => "y"
      q "Brake levers can't touch the handlebars", :pick => :one, :correct => "y"
    end

  end
end
