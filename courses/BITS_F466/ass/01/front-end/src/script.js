var gateway = "http://localhost:3000"
var code_2_country_api = gateway + "/api/country/"
var country_2_code_api = gateway + "/api/code/"


$(document).ready(function() {
    $("#country-submit").click(function() {
        $.ajax({
            url: code_2_country_api + $("#country-input").val(),
            type: "GET",
            dataType: "json",
            timeout: 3000,
            success: function(data) {
                $("#country-output").removeClass('text-danger')
                $("#country-output").addClass('text-success')
                $("#country-output").html("Country : " + data.country)
            },
            error: function(xmlhttprequest, textstatus, message) {
                $("#country-output").removeClass('text-success')
                $("#country-output").addClass('text-danger')
                if(textstatus==="timeout") {
                    $( "#country-output" ).html("got timeout");
                } else {
                    $( "#country-output" ).html(message);
                }
            }
        })
    });

    $("#code-submit").click(function() {
        $.ajax({
            url: country_2_code_api + $("#code-input").val(),
            type: "GET",
            dataType: "json",
            timeout: 3000,
            success: function(data) {
                $("#code-output").removeClass('text-danger')
                $("#code-output").addClass('text-success')
                $("#code-output").html("Code : " + data.code)
            },
            error: function(xmlhttprequest, textstatus, message) {
                $("#code-output").removeClass('text-success')
                $("#code-output").addClass('text-danger')
                if(textstatus==="timeout") {
                    $( "#code-output" ).html("got timeout");
                } else {
                    $( "#code-output" ).html(message);
                }
            }
        })
    })
})
