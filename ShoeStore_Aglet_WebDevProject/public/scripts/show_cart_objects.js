/**
 * This is the cart table
 */
$(document).ready(function() {

    /**
     * There is a p tag with id cart_items that contains the string of the cart information.
     */
    //get cart
    var cart_items = document.getElementById("cart_items").innerHTML.split("},{");//str.split(" ")
    
    var cart_id_quantity = {};
    for(var i = 0; i < cart_items.length; i++){
        var regex = /\d+/g;

        var cart_product_id = cart_items[i].split(",")[1].match(regex)[0];
        var cart_product_quantity = cart_items[i].split(",")[2].match(regex)[0];

        //this changes the string to a map
        cart_id_quantity[cart_product_id] = cart_product_quantity;
    }

    console.log(cart_id_quantity);

    var results = $("#all-products");
    results.addClass("gallery");

    var table_body = $("#table_body");
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

            if (cart_id_quantity[sid] !== undefined){
                //Draw cart

                // tr
                //     th(scope="row") 1
                //     td name
                //     td price
                //     td Quantity

                var tr = $("<tr>");

                //////image
                var th = $("<th>");
                th.attr('scope', 'row');
                
                //create image object
                var image = $("<img>");
                image.addClass("img-fluid");
                image.addClass("product-image-thumbnail");
                image.addClass("image");
                image.attr("src", picture_url);
                th.append(image);

                //add th to tr
                tr.append(th);

                //////add name
                var name_td = $("<td>");
                name_td.append("<p>" + name + "</p>");

                //add th to tr
                tr.append(name_td);


                //////add price
                var price_td = $("<td>");
                price_td.append("<p>" + "$" + price + " CAD" + "</p>");

                //add th to tr
                tr.append(price_td);


                //add quantity
                //////add quantity
                var quantity_td = $("<td>");
                quantity_td.append("<p>" + cart_id_quantity[sid]  + "</p>");

                //add th to tr
                tr.append(quantity_td);


                // //Trash button
                // var trash_td = $("<td>");
                // var trash_td_form = $('<form action="/updateCart_remove_item" method="POST">');
                // //input#product_id(hidden type='text', name='product_id' value=product_sid)
                // trash_td_form.append('<input hidden type="text" name="product_id" value=' + sid + ">");
                // trash_td_form.append('<button class="button is-link is-rounded" type="submit">' + '<i class="fa fa-trash" ' + 'id=' + sid + '></i>' + "</p>");
                // trash_td.append(trash_td_form);
                // tr.append(trash_td);


                table_body.append(tr);
                
            }
            
            //Total row.
            // var tr = $("<tr>");
            // var th = $("<th>");
            // th.attr('scope', 'row');
            // th.append('<p><b>Total: </b></p>');
            // tr.append(th);
            // tr.append();
            
            
            
        });
        
        //Clicking on the product event
        $("i").click(function(){
            // console.log("Delete this item: " + this.id);

            //remove from table.
            var table_row = this.parentNode.parentNode.parentNode.parentNode;
            console.log(table_row.tagName);
            table_row.parentNode.removeChild(table_row);

            //remove from account db (send post request to modify db)
            //sid = this.id;
        });

    });


    
});


