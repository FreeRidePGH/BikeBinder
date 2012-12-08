$(document).ready(function(){

        var numBikes = 10;
        var count;

        // Attach Click/Tap Listeners
        function attachListeners(){
            onScrollBottom();
            filterListener();
        }

        // Function called when scrolling to bottom of screen
        function onScrollBottom(){
            $(window).scroll(scrollHandler);
            $(".sorter").each(function(){
                $(this).click(function(){
                    $(".active").removeClass("active");
                    $(this).addClass("active");
                    $("#footerLink").html("Loading...");
                    populateBikeList();
                });
            });
            $("#bikeTableBody tr").live("click",function(){
                var bikeNumber = $(this).children()[0];
                window.location.href = "/mobile/show/"+bikeNumber.innerHTML;
                return;
            });

        }

        // Scroll Pagination
        var scrollHandler = function(){
            var dHeight = getDocHeight();
            // Detect scroll to the bottom of the screen, load more bikes
            if($(window).scrollTop() + window.innerHeight >= dHeight - 10){
                $(window).unbind("scroll");
                $("#footerLink").html("Loading...");
                loadBikes();
            }
        }

        // Repopulate bike list when filters are pressed
        function filterListener(){
            $("#colorFilter").change(function(){
                populateBikeList();
            });
            $("#statusFilter").change(function(){
                populateBikeList();
            });
        }

        // Cross Browser Document Height
        function getDocHeight() {
            var D = document;
            return Math.max(
                Math.max(D.body.scrollHeight, D.documentElement.scrollHeight),
                Math.max(D.body.offsetHeight, D.documentElement.offsetHeight),
                Math.max(D.body.clientHeight, D.documentElement.clientHeight)
            );
        }

        // Get the SQL field to sort by
        function getSorter(){
            return $(".active").attr("sortAttr");
        }

        // Ajax request to get list of bikes on button presses
        function populateBikeList(){
            $("#bikeTableBody").html("");
            numBikes = 0;
            var bikeStatus = $("#statusFilter").val();
            var bikeColor = $("#colorFilter").val();
            $.ajax({
                type : "GET",
                url : "/mobile/filter_bikes",
                data : {
                    "sortBy" : getSorter(),
                    "searchDesc" : "",
                    "status" : bikeStatus,
                    "color" : bikeColor,
                    "min" : numBikes,
                    "max" : numBikes + 10,
                    "all" : "false"
                },
                dataType : "json",
                success: function(response){
                    count = parseInt(response.count);
                    renderHtml(response);
                }
            });
        }

        // AJAX request to get list of bikes on scroll to bottom
        function loadBikes(){
            var bikeStatus = $("#statusFilter").val();
            var bikeColor = $("#colorFilter").val();
            $.ajax({
                type : "GET",
                url : "/mobile/filter_bikes",
                data : {
                    "sortBy" : getSorter(),
                    "searchDesc" : "",
                    "status" : bikeStatus,
                    "color" : bikeColor,
                    "min" : numBikes,
                    "max" : numBikes + 10,
                    "all" : "false"
                },
                dataType : "json",
                success: function(response){
                    // Get the count of the returned list
                    count = parseInt(response.count);
                    // If we haven't reached the end of the list display the bikes
                    if(numBikes + 10 < count){
                        renderHtml(response);
                    }
                    // Set the footer text
                    $("#footerLink").html("Back To Top");
                }
            });
        }

        // Renders html given the JSON response from the ajax request
        function renderHtml(response){
            var bikes = response.bikes;
            // Check for no bikes
            if(bikes.length === 0){
                var bikeRow = document.createElement("tr");
                var bikeInfo = document.createElement("td");
                bikeInfo.innerHTML = "No Bikes Found";
                $(bikeRow).append(bikeInfo);
                $("#bikeTable").append(bikeRow);
            }
            // Render all of the bikes to the table
            for(var i = 0; i < bikes.length; i++){
                var bike = bikes[i];
                var bikeRow = document.createElement("tr");
                var bikeNumber = document.createElement("td");
                bikeNumber.innerHTML = bike.number;
                var bikeStatus = document.createElement("td");
                bikeStatus.innerHTML = (bike.departed_at ? bike.name + " - Departed" : (bike.name || "Available"));
                var bikeHook = document.createElement("td");
                bikeHook.innerHTML = bike.hook_number || "n/a";
                var bikeColor = document.createElement("td");
                bikeColor.innerHTML = bike.color;
                $(bikeRow)
                .append(bikeNumber)
                .append(bikeStatus)
                .append(bikeHook)
                .append(bikeColor);
                $("#bikeTable").append(bikeRow);
            }
            numBikes += 10;
            $(window).bind("scroll",scrollHandler);
            $("#footerLink").html("Back To Top");
            return false;
        }

        attachListeners();
    });

