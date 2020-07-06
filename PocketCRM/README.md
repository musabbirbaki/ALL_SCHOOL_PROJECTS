<h1 id="pocketcrm">PocketCRM</h1>
<p>A Basic CRM in your pocket</p>
<p>By: Yash Pandya (100519180),Tehseen Chaudhry (100618539), Musabbir Baki (100640494)</p>
<h2 id="user-guide">User Guide</h2>
<p>When the application is first installed, the user will be greeted with a login screen.</p>
<p align="center">
  Login Page
  <br><br>
  <img src="https://lh3.googleusercontent.com/cBRB6aUlEhgsFZaLQFBduCYrZN1MpJFBDntA_3O3Pj-4vlALwk59K8nHqkYxEZdqiS7Ju-gDmj1_">
</p>
<p>If this is the first time the application is launched the user is required to register.</p>
<p align="center">
  Registeration Page
  <br><br>
  <img src="https://lh3.googleusercontent.com/NhCHEtud5-Gph9dALlxlfnPFPQ_tBFdzir1_uRWaZPCrFTy3UqnIZR39Ypm5oz_kriUw2e-CGG_A">
</p>
<p>Once that is done the user can then login, the will then be greeted by an empty dashboard screen. They will have to drag out the drawer by either pressing the drawer button on swiping from the left edge of the phone to the right.</p>
<p align="center">
  Drawer 
  <br><br>
  <img src="https://lh3.googleusercontent.com/u6Vy1a-_Y4mkly3ZSJk0iJVdDWwhVNgPw9OAc1J7-AKJFNn81a_7us4CsL2OeCcU9L7HqzZAFniD">
</p>
<p>They will then have to click on the Tables link that will take them to the tables page, which will list all the tables they have. Initially it will be empty so they will have to create a table by clicking the add table button.</p>
<p align="center">
 Empty Table Page 
  <br><br>
  <img src="https://lh3.googleusercontent.com/LOgbO3WuiPUwddHfc_ND8NthQDPZsbr4t2AtJnAscGsY84_N0kDRVRCxigTUD8ZGxOzOFr0k1Qd8">
</p>
<p>After completing the process, they can go into the table by clicking the tile with the table.</p>
<p align="center">
  Table Page 
  <br><br>
  <img src="https://lh3.googleusercontent.com/jCHoOD-unxNGlRQr4f1kVmTvPAn6BvEj4oRngCUkCH70t8WfEbX59NYhgjdyEeiBeJUJcEzu5Qd-">
</p>
<p>This will navigate to the ListEntities page were all the data of there tables will be listed. If the table was recently created then, they will have to first add attributes, then they will be able to add data to the table.</p>
<p align="center">
  Drawer 
  <br><br>
  <img src="https://lh3.googleusercontent.com/u6Vy1a-_Y4mkly3ZSJk0iJVdDWwhVNgPw9OAc1J7-AKJFNn81a_7us4CsL2OeCcU9L7HqzZAFniD">
</p>
<p>To add attributes, the user will have to press the add attribute button, and after specifying the attributes they would like to add the can now add table data by pressing the create entity button.</p>
<p align="center">
  Add Attributes Form 
  <br><br>
  <img src="https://lh3.googleusercontent.com/jNnfygBXRVnHAJi8ePIVzcvhdl_Ev0pUZNucrX_K-l9ii21vxTiCdNtGPuYIZ9w4fSq3Cm0fxNIx">
  <br><br>
  Add Entity Form 
  <br><br>
 <img src="https://lh3.googleusercontent.com/kQ4Zdmze8Ti53BUOUWXgkGoSQkUTZj0KVHxuyhLZTx9j7Gza50nje8vUVc7ZyWTr5LdvIeiCZLIZ">
</p>
![enter image description here]()
After completing the process the entity will now appear on the screen. To Get more detail about the entity they can click on the entity and it will take them to a detailed entity page, where they can edit the data.
<p align="center">
  List Entity Page
  <br><br>
  <img src="https://lh3.googleusercontent.com/uquUGCfe5zoTKLYq56uhbvECo43EQioz5_o1B2EipjVkR_lU8Aiwhq8XrA3g_QowPs95GEAjyArc">
  <br><br>
 Detailed Entity Page
  <br><br>
  <img src="https://lh3.googleusercontent.com/SCxww5xvUnHM7upyyscxF__x_jafJmEEKHvpTVPT4b30GmHBbIJqqJtxXu3lItJKKxRgw8iJbQeQ">
 </p>
<p>Once they are satisfied with the data, the user can now create a new dashboard element they do this by navigating to the dashboard page and pressing the create dashboard button. After providing the data required the dashboard element would be created.</p>
<p align="center">
  Create Dashboard element
  <br><br>
  <img src="https://lh3.googleusercontent.com/YH8F6GlpUetG4PZ4bqZ66YvEUVylJSOEfcs2kvxrOllQ31pwYpPB3VeXgZgc6yuOE_PAjVNjvoro">
</p>
<p>If they would like more details about the dashboard they can click on the element and it will take them to the detailed dashboard element page. They can then view all the relevant data about the dashboard element.</p>
<p align="center">
Dashboard page
  <br><br>
  <img src="https://lh3.googleusercontent.com/EGKMhRW9KG6TJx4XxWDJzq9DewnUh6U5kc4asSwpqcKI69f01py3pxhxN8fQe666_Ia5_XJR_tGw">

</p>

## Internalization
<p align=center>The language used for many menu options and buttons can be translated to French. If the system language is changed to French Canada, the user will notice the following changes to the language:

  <img src="https://i.imgur.com/gX3YnXd.png"
  height=500>
  <br>
  <img src="https://i.imgur.com/vsfq2aP.png"
  height=500>
  <br>
  <img src="https://i.imgur.com/pMSdR2h.png"
  height=500>
  </p>
<h2 id="bugs">Bugs</h2>
<p>Unfortunaly we had a few errors, when we try to load the data from firebase to insert into the local database. The firebase data would only add the data to the last table created due to a few multiple asyncronous calls being made to the loacl db. We tried to snyncronize the function, but to no avail 😢. We were able to print the data to the console.</p>


