/**
 * this function draws gallery images, names and price tag on all products apage
 */
$(document).ready(function() {

    var results = $("#all-products");
    results.addClass("gallery");
    var all_products;
    $.getJSON("/json/allProducts", function(response) {
        all_products = response;
        results.innerHTML = all_products;
        $(all_products).each(function() {
            var sid = this['sid'];
            var name = this['name'];
            var picture_url = this['picture_url'];
            var description = this['description'];
            var price = this['price'];
            var rating = this['rating'];
            var stock = this['stock'];

            var div = $("<div>");
            div.addClass("mb-3");

            var product_div = $("<div>");
            product_div.addClass("product_div");
            product_div.attr('id', 'product_' + sid);
            
            var image = $("<img>");
            product_div.append(image);
            image.addClass("img-fluid");
            image.addClass("product-image");
            image.addClass("image");
            image.attr("src", picture_url);

            var info_div = $("<div>");
            info_div.addClass("middle");
            // info_div.style.opacity = "0";

            var info = $("<div>");
            info.addClass("text");
            //label writing
            info.append("<p>" + name + "<br>$" + price + "</p>")

            product_div.append(info_div);
            div.append(product_div);

            //price tag opacity
            $(".product_div").hover(function(){
                $(this)[0].childNodes[1].style.opacity = "1";            
                }, function(){
                    $(this)[0].childNodes[1].style.opacity = "0";
            });

            div.append(product_div);
            info_div.append(info);
            
            results.append(div);
        });
        
        //Clicking on the product event
        $(".product_div").click(function(){
            console.log(this.id);
            // window.location.href = "all/" + this.id;
            window.location.href = this.id;

        });
    });


    
});


