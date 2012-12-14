$(document).ready(function(){
        
        // Attach Form Listeners
        function attachListeners(){
            formSubmit();
        }

        function formSubmit(){
            $("#mobileForm").submit(function(e){
                // Empty the error list
                $("#addErrors").html("");
                // Get errors and display
                var errors = processValidations();
                if(errors.length > 0){
                    for(var i = 0; i < errors.length; i++){
                        var newError = document.createElement("li");
                        newError.innerHTML = errors[i];
                        $("#addErrors").append(newError);
                        // Go to the top of the page to see errors
                        window.location.href = "#addErrors";
                    }
                    return false;
                }
            });
        }

        // Checks for valid bike number format
        function processValidations(){
            var errors = [];
            var bikeNumber = $("#bike_number").val();
            var bikeSeat = $("#bike_seat_tube_height").val();
            var bikeTop = $("#bike_top_tube_length").val();
            var bikeValue = $("#bike_value").val();
            if(isNaN(bikeNumber) == true || bikeNumber.length !== 5){
                errors.push("Bike Number must be 5 digits");
            }
            if(bikeSeat && isNaN(bikeSeat)){
                errors.push("Seat Tube must be a number");    
            }
            if(bikeTop && isNaN(bikeTop)){
                errors.push("Top Tube must be a number");    
            }
            if(bikeValue && isNaN(bikeValue)){
                errors.push("Value must be a number");    
            }
            return errors;
        }

        attachListeners();
});

