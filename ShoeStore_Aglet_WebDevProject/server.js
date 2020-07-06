var express = require('express');
var app = express();

var session = require('express-session');
var mongoose = require('mongoose');
var bcrypt = require('bcrypt-nodejs');
var bodyParser = require('body-parser');
var uuid = require('uuid/v1');

// database config
mongoose.Promise = global.Promise
mongoose.connect('mongodb://localhost:27017/redaglet', {
      useNewUrlParser: true
   },
   function(error) {
      if (error) {
         return console.error('Unable to connect:', error);
      }
   });

mongoose.set('useCreateIndex', true);

app.set('trust-proxy', true);
app.use(session({
   genid: function(request) {
      return uuid();
   },
   resave: false,
   saveUninitialized: false,
   secret: 'red october',
}));

//public directory
app.use(express.static('public'));
app.use(bodyParser.urlencoded({extended: false}));

//use pug files from biews folder
app.engine('pug', require('pug').__express)
app.set('views', __dirname + '/views');
app.set('view engine', 'pug');

//creates db for the Accounts
var Schema = mongoose.Schema;
var accountSchema = new Schema({
  name: String,
  email: String{
    type: String,
    unique: true,
    index: true
  },
  encryptedPass: String,
  phone: String,

  //Added cart array
  cart: [{
    product: Number,
    quantity: Number}]
},{
   collection: 'accounts'
});
var Account = mongoose.model('account', accountSchema);

//Define product schema
var productSchema = new Schema({
  sid: {type: Number, unique: true},
  name: String,
  picture_url: String,
  description: String,
  price: Number,
  rating: Number,
  stock: Number
  }, {collection: 'products'});
  var Product = mongoose.model('product', productSchema);

//main page, allows it to be accessed from / and /home
app.get(['/home','/'], function(request, response) {
  name = request.session.name;
  email = request.session.email;
  response.render('home', {
    title: 'Home',
    description: 'This is the main page',
    name: name,
    email: email
  });
});

//account details page
app.get('/accountDetails', function(request, response) {
  name = request.session.name;
  email = request.session.email;
  Account.find({email: email}).then(function(results){

  response.render('details', {title: 'Account Details',
    description: 'About You',
    name: name,
    email: email,
    phone: results[0].phone
    });
  });
});

//when the form to update account details is submitted
app.post('/updateDetails', function(request, response){
  newName = request.body.name;
  newPhone = request.body.phone;
  Account.find({email: request.session.email}).then(function(results){
    Account.updateOne({email:email}, {name:newName, phone:newPhone}, function(error){
      if (error) {
        response.render('details', {result: 'Could not update'});
      } else {
        response.render('details', {name:newName, email:email, phone: newPhone,
          result: 'Sucessfully updated values'});
      }
    });
  });
});

//when the form to change password is submitted
app.post('/changePassword', function(request, response){
  oldPass = request.body.oldPass;
  newPass = request.body.newPass;
  newPassVerify = request.body.newPassVerify;

  //finds account
  Account.find({email: request.session.email}).then(function(results) {
    //checks if old passwords match
    if (bcrypt.compareSync(oldPass, results[0].encryptedPass)){
      //checks if the new passwords match
      if (newPass === newPassVerify){
        encryptedNew = bcrypt.hashSync(newPass);
        //updates db
        Account.updateOne({email: email},
          {encryptedPass: encryptedNew}, function(error){
            if (error){
              response.render('details', {result: 'Could not update'});
            } else {
              response.render('details', {result: 'Password updated successfully'});
            }
          });

      } else {
        response.render('details', {result: 'New Passwords do not match'});
      }
    } else {
      response.render('details', {result: 'Old passwords do not match'});
    }
  });

});

//checkout page
app.get('/checkout', function(request, response) {
  name = request.session.name;
  email = request.session.email;

  Account.findOne({email: email}, function(err, account){
    //check if item is already in account
    //if it is already in, then update it
    //if not in account then add it
    response.render('checkout', {title: 'Checkout',
      description: 'Checkout of Redaglet',
      name: name,
      email: email,

      cart_items: account["cart"]
    });
  });
});

//login page
app.get('/login', function(request, response) {
  response.render('login', {
    title: 'Login',
    description: 'The login page',
  });
});

//submits log on form
app.post('/logon', function(request, response) {
   email = request.body.email;
   password = request.body.pass;

   //finds account
   Account.find({email: email}).then(function(results) {
      if (results.length != 1) {
         console.log('Account does not exist under that account');
         response.render('login', {
                  errorMessage: 'Login Invalid'
                  });
      } else {
        if (bcrypt.compareSync(password, results[0].encryptedPass)) {
            request.session.email = email;
            request.session.name = results[0].name;
            name = results[0].name;
            response.render('home', {
               name: name,
               email: email,
               title: 'Sucessful Login'
            });
         } else {
            response.render('login', {
               errorMessage: 'Incorrect password or email address'
            });
         }
      }
   }).catch(function(error) {
      response.render('login', {
         errorMessage: 'Can\'t login'
      });
   });
});

//signup page redirect
app.get('/signup', function(request, response) {
  response.render('signup', {
    title: 'Signup',
    description: 'The signup page',
  });
});

//registers the user
app.post('/register', function(request, response) {
  //gets the form items
  name = request.body.name;
  email = request.body.email;
  pass = request.body.password;
  phone = request.body.phone;

  //encrypts pass and makes the account
  encryptedPass = bcrypt.hashSync(pass);
  newAccount = new Account({
    name: name,
    email: email,
    encryptedPass: encryptedPass,
    phone: phone
  });

  //adds the account into the db
  newAccount.save(function(error){
    if (error){
      response.render('signup', {error: 'Email already in use'});
    } else {
      request.session.email = email;
      request.session.name = name;
      response.render('home', {name: name,
                               email:email});
    }
  });
});

//logs the user out by resetting the fields
app.get('/logout', function(request, response) {
   request.session.name = '';
   request.session.email='';
   response.redirect('/');
});

//runs server on port 3000
app.set('port', process.env.PORT || 3000);
app.listen(app.get('port'), function() {
  console.log('Server running on port ' + app.get('port'));
});


////////////////////////////Products stuff///////////////////////////

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
  // we're connected!
  // GENERATE_DUMMY_ITEMS_ONCE();

});

app.get('/json/allProducts', function(req, res){ //get a response
  // res.send("Hello world");//send somthing to browser
  products_results = req.session.products_results

  Product.find({}).then(function(results) {
    if (results.length > 0) {
        res.send(results);
    } else {
        console.log("No products found. GERATING DUMMY PRODUCTS.");
        GENERATE_DUMMY_ITEMS_ONCE();
        console.log("GERATED DUMMY PRODUCTS.");
        res.send(results);

    }
  });
});

app.get('/all', function(req, res){ //get a response
  res.render('all_products', { //response with render add_article.pug
    title:'All Products',
    subtitle: 'All Products'
  });
});


//get product page information
app.get('/product_:id', function(req, res){ //get a response
  Product.find({sid:req.params.id}).then(function(results) {
    // console.log(results);
    res.render('product_detail_page', {
      // json: results,
      product_sid: results[0]['sid'],
      product_name: results[0]['name'],
      product_picture_url: results[0]['picture_url'],
      product_description: results[0]['description'],
      product_price: results[0]['price'],
      product_rating: results[0]['rating'],
      product_stock: results[0]['stock'],
    });
  });
});


//adding cart item to account
app.post('/updateCart', function(req, res){
  var product_quantity = req.body.product_quantity;
  var product_id = req.body.product_id;

  var new_cart = {product: product_id, quantity: product_quantity };

  Account.findOne({email: req.session.email}, function(err, account){
    account.cart.push(new_cart);
    account.save();
    // console.log(account);
  });
});

//remove all item from cart item to account
app.post('/updateCart_remove_all_item', function(req, res){

  Account.update({email: req.session.email}, { $set: { cart: [] }}, function(err, res){
    console.log('affected: ', res);
    // res
    // alert("Items Purchased. Account Cart Emptied.");
  });
  console.log("Items Purchased. Account Cart Emptied.");
  res.redirect('/home');
});

//remove cart item to account
app.post('/updateCart_remove_item', function(req, res){
  var delete_product_id = res.body.product_id;
  console.log("Delete: " + delete_product_id + " THIS");

});



////////////////////////////////////Product Funtions///////////////////////////////////////////////////
/*
    This function adds a product to the database. works....
*/
function add_product(sid_v, name_v, picture_url_v, description_v, price_v, rating_v, stock_v){
    //Initialize product
    var newProduct = new Product({sid: sid_v,
                                name: name_v,
                                picture_url: picture_url_v,
                                description: description_v,
                                price: price_v,
                                rating: rating_v,
                                stock: stock_v
                                });

    //save product in db
    newProduct.save(function(error) {
        if (error) {
            // insert failed
            console.log('error while adding product:', error);
        } else {
            // insert successful
            console.log("Product " + name_v + " added.");
        }
    });
}

/*
    Update a product
*/
function update_product(name_v, picture_url_v, description_v, price_v, rating_v, stock_v){
    Product.update({sid: sid},
        {name: name_v},
        {picture_url: picture_url_v},
        {description: description_v},
        {price: price_v},
        {rating: rating_v},
        {stock: stock_v},
        function(error, numAffected){
            if((error) || (numAffected.nModified != 1)){
                // The Product was not updated
                console.log("Errored, Product " + name_v + "wasn't updated. Error: " + error);

            }else{
                //The Product was Updated
                console.log("Product " + name_v + " updated.");

            }
        });
}

/*
    This function modifies product stock
*/
function update_product_stock(name, stock_v){
    Product.update({sid: sid},
        {name: name},
        {picture_url: picture_url},
        {description: description},
        {price: price},
        {rating: rating},
        {stock: stock_v},
        function(error, numAffected){
            if((error) || (numAffected.nModified != 1)){
                // The Product was not updated
                console.log("Errored, Product " + stock_v + "wasn't updated. Error: " + error);

            }else{
                //The Product was Updated
                console.log("Product " + stock_v + " updated.");

            }
        });
}

/*
    This function modifies product rating
*/
function update_product_rating(name, rating_v){
    Product.update({sid: sid},
        {name: name},
        {picture_url: picture_url},
        {description: description},
        {price: price},
        {rating: rating_v},
        {stock: stock},
        function(error, numAffected){
            if((error) || (numAffected.nModified != 1)){
                // The Product was not updated
                console.log("Errored, Product " + rating_v + "wasn't updated. Error: " + error);

            }else{
                //The Product was Updated
                console.log("Product " + rating_v + " updated.");

            }
        });
}

/*
    This function modifies product rating
*/
function update_product_description(name, description_v){
    Product.update({sid: sid},
        {name: name},
        {picture_url: picture_url},
        {description: description_v},
        {price: price},
        {rating: rating},
        {stock: stock},
        function(error, numAffected){
            if((error) || (numAffected.nModified != 1)){
                // The Product was not updated
                console.log("Errored, Product " + description_v + "wasn't updated. Error: " + error);

            }else{
                //The Product was Updated
                console.log("Product " + description_v + " updated.");

            }
        });
}

/*
    This function modifies product name
*/
function update_product_name(name, name_v){
    Product.update({sid: sid},
        {name: name_v},
        {picture_url: picture_url},
        {description: description},
        {price: price},
        {rating: rating},
        {stock: stock},
        function(error, numAffected){
            if((error) || (numAffected.nModified != 1)){
                // The Product was not updated
                console.log("Errored, Product " + name_v + "wasn't updated. Error: " + error);

            }else{
                //The Product was Updated
                console.log("Product " + name_v + " updated.");

            }
        });
}

/*
    This function modifies product price
*/
function update_product_price(name, price_v){
    Product.update({sid: sid},
        {name: name},
        {picture_url: picture_url},
        {description: description},
        {price: price_v},
        {rating: rating},
        {stock: stock},
        function(error, numAffected){
            if((error) || (numAffected.nModified != 1)){
                // The Product was not updated
                console.log("Errored, Product " + price_v + "wasn't updated. Error: " + error);

            }else{
                //The Product was Updated
                console.log("Product " + price_v + " updated.");

            }
        });
}

/*
    This function modifies product name using sid
*/
function update_product_price(sid, name_v){
    Product.update({sid: sid},
        {name: name_v},
        {picture_url: picture_url},
        {description: description},
        {price: price},
        {rating: rating},
        {stock: stock},
        function(error, numAffected){
            if((error) || (numAffected.nModified != 1)){
                // The Product was not updated
                console.log("Errored, Product " + price_v + "wasn't updated. Error: " + error);

            }else{
                //The Product was Updated
                console.log("Product " + price_v + " updated.");

            }
        });
}


/*
    This function deletes the product using name. works...
*/
function delete_product(name_v){
    Product.find({name: name_v}).remove(function(error, numAffected){
        if((error) || (numAffected.nModified != 1)){
            // The Product was not updated
            console.log("Errored, Product " + name_v + "wasn't deleted. Error: " + error);

        }else{
            //The Product was Updated
            console.log("Product " + name_v + " deleted.");

        }
    });
}

function delete_product_sid(sid_v){
  Product.find({sid: sid_v}).remove(function(error, numAffected){
      if((error) || (numAffected.nModified != 1)){
          // The Product was not updated
          console.log("Errored, Product " + sid_v + "wasn't deleted. Error: " + error);

      }else{
          //The Product was Updated
          console.log("Product " + sid_v + " deleted.");

      }
  });
}

function GENERATE_DUMMY_ITEMS_ONCE(){
    product_names = ["Shoe", "Jacket", "Not Vans", "Shoe Lace", "Yeezy Boost", "Boring Adidas", "Running Shoe", "Not Doc Martens", "Converse", "Adidas Shoes", "Low-Top Converse", "Not Vans", "Aligator Shoes", "Dress Shoes",
    "Standard Shoe", "Casual Shoe", "Winter Shoe", "General Shoe", "Hiking Boots", "Boat shoes"]

    product_urls = [
      "https://images.pexels.com/photos/1159670/pexels-photo-1159670.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      "https://images.pexels.com/photos/267294/pexels-photo-267294.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/531892/pexels-photo-531892.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/1280064/pexels-photo-1280064.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/1619652/pexels-photo-1619652.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/1895019/pexels-photo-1895019.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/1467574/pexels-photo-1467574.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/87835/pexels-photo-87835.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/1161530/pexels-photo-1161530.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/1261005/pexels-photo-1261005.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      "https://images.pexels.com/photos/1447262/pexels-photo-1447262.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/296158/pexels-photo-296158.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/999455/pexels-photo-999455.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/1161538/pexels-photo-1161538.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/293404/pexels-photo-293404.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/52528/shoes-laces-shop-shopping-52528.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/906361/pexels-photo-906361.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/760612/pexels-photo-760612.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
      "https://images.pexels.com/photos/1282616/pexels-photo-1282616.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260"
    ]
    var name;
    for(var i = 0; i < 21; i++){
        name = product_names[i];
        url = product_urls[i];
        add_product(      i , name, url, "This is a and its really nice.",  i*13.0,      i%5,      50);
    }
}
