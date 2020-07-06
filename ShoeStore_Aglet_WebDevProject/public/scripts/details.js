$(document).ready(function(){
  $('#changePass').click(function(){
    //toggles visibility of change pass button
    $('#changePass').toggle();

    //creates a cancel button to avoid changing pass box
    var cancelPass = document.createElement('button');
    cancelPass.innerHTML ='Cancel';
    $(cancelPass).addClass('btn btn-dark detailBtn');
    cancelPass.style.float = 'right';
    $('#changePassBox').prepend(cancelPass);

    //creates a form for changing pass
    var form = document.createElement("FORM");
    form.action='/changePassword';
    form.method='post';

    //input for user old password to ensure they are qualified to change password
    var oldPass = document.createElement("INPUT");
    oldPass.type='password';
    oldPass.setAttribute('id', 'oldPass');
    oldPass.setAttribute('name', 'oldPass');

    //input for new pass
    var newPass = document.createElement("INPUT");
    newPass.type='password';
    newPass.setAttribute('id', 'newPass');
    newPass.setAttribute('name', 'newPass');

    //check to match new passwords
    var newPassVerify = document.createElement("INPUT");
    newPassVerify.type='password';
    newPassVerify.setAttribute('id', 'newPassVerify');
    newPassVerify.setAttribute('name', 'newPassVerify');

    //submission button
    var submit = document.createElement("INPUT");
    submit.type = "submit";
    $(submit).addClass('btn btn-dark submission detailBtn');
    submit.style.display="block";

    var h5 = document.createElement("H5");

    //changes h5 element for different titles
    h5.innerHTML="Old Password";
    form.append(h5.cloneNode(true),oldPass);
    h5.innerHTML="New Password";
    form.append(h5.cloneNode(true), newPass);
    h5.innerHTML="Re-Enter New Password";
    form.append(h5.cloneNode(true), newPassVerify, submit);

    //appends form
    $("#changePassBox").append(form);

    //cancels the pass change
    $(cancelPass).click(function(){
      form.remove();
      cancelPass.remove();
      $('#changePass').toggle();
  });
});

//to edit entire acc details
  $('#edit').click(function(){
    $('#edit').addClass('swapButton');

    //cancel form
    var cancel = document.createElement('button');
    cancel.style.float ='right';
    cancel.innerHTML ='Cancel';
    $(cancel).addClass("btn btn-dark detailBtn");
    $('#account').prepend(cancel);

    //element for modifying name
    var name = document.createElement("INPUT");
    name.setAttribute('id', 'name');
    name.setAttribute('name', 'name');
    name.setAttribute('value', $('#name').text());
    var oldName = $('#name').text();
    $('#name').html('');

    //element for modifying phone
    var phone = document.createElement("INPUT");
    phone.setAttribute('id', 'phone');
    phone.setAttribute('name', 'phone');
    phone.setAttribute('value', $('#phone').text());
    var oldPhone = $('#phone').text();
    $('#phone').html('');

    //submit button to replace edit button
    var submit = document.createElement("INPUT");
    submit.type = "submit";
    $(submit).addClass('btn btn-dark submission detailBtn');
    submit.style.display="block";
    $(submit).html('Save');

    $('#update').append(name,phone,submit);

    $("#name").append(name);
    $("#phone").append(phone);
    $('#account').append(submit);

    //resets page on submission
    $(submit).click(function(e){
      $('#name').html($(name).val());
      $('#phone').html($(phone).val());


      $('#edit').removeClass('swapButton');
      $(cancel).remove();
      $(submit).remove();
      e.preventDefault(); //prevents page from refreshing
    });

    //cancel the Edit
    $(cancel).click(function(e){
      $('#name').html(oldName);
      $('#phone').html(oldPhone);

      $(cancel).remove();
      $(submit).remove();
      $(name).remove();
      $(phone).remove();
      $('#edit').removeClass('swapButton');
      e.preventDefault();
    });
  });


//ajax for getting user country and city
  $.ajax('http://ip-api.com/json').then(
        function success(response) {
            $('#country').html(response.country);
            $('#city').html(response.city);
        },
        function fail(data, status) {
          $('#country').html("Could not retrieve country");
          $('#city').html("Could not retrieve city");
        }
    );
});
