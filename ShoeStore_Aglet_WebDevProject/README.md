# WebDev_Final_Project
CSCI 3230U: Web Application Development Final Project: HTML, CSS, JavaScript, jQuery, Node.js, Express, MongoDB, AJAX

How to Run:
> git clone https://github.com/musabbirbaki/WebDev_Final_Project.git

> cd WebDev_Final_Project/

> npm install

> nodemon

Then navigate to http://localhost:3000/ Mozilla or Chrome. IE/Edge may cause some styling issues.

How the DB is populated:
- Initially, the Database will automatically be filled with a number of dummy products. The method GENERATE_DUMMY_ITEMS_ONCE() runs to make this happen.
- To make a user account, please click on the Login button and register. This will allow you to access your Cart.
- To add more items to the Database, mongo has to be accessed or alternatively use the
function add_product(sid_v, name_v, picture_url_v, description_v, price_v, rating_v, stock_v) in 
db.once('open', function() {}); function.
- An admin account was not created for this project.

