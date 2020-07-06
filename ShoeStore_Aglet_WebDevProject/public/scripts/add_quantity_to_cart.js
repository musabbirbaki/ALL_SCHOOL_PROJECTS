//This functoin just changes cart number
$(document).ready(function() {
    var cart_quantity = document.getElementById("add_to_cart_quantity");
    // console.log(cart_quantity);
    
    $("#add_to_quantity").click(function(){
        cart_quantity.value = parseInt(cart_quantity.value) + 1;
        // console.log("Value: " + cart_quantity.value);
        
    });

    $("#sub_from_quantity").click(function(){
        // console.log("+");
        var quantity = parseInt(cart_quantity.value);
        if(quantity > 0){
            cart_quantity.value = quantity - 1;
        }
    });
});