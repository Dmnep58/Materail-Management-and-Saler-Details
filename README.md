<h1>RAP Application: Materials, Salers, and Images Management</h1>
<p>This project is a RAP (RESTful ABAP Programming) application that manages materials, salers (sellers), and their associated images. <br>
The system allows users to perform CRUD (Create, Read, Update, Delete) operations on these entities and implements business logic to ensure data consistency and correct associations.</p>

<hr>
<u><h4>Table Structure</h4></u>
<h5>1. Salers Table (zsalers_table)</h5>
<p><b>Purpose:</b> Stores information about the salers (sellers) such as their ID, name, and address.<br>
<b>Key Fields:</b><br>
saler_id: Unique identifier for each saler.<br>
name: The name of the saler.<br>
address: Address of the saler.</p>

<h5>2. Materials Table (zmaterials_table)</h5>
<p><b>Purpose:</b>Purpose: Contains material-related data including material number, type, price, quantity, and the seller it is linked to.
</p>
<p><b>Key Fields:</b><br>
material_number: Unique identifier for each material.<br>
material: Material description.<br>
price: Price of the material.<br>
quantity: Quantity of the material in stock.<br>
salerid: Reference to the seller (saler) for the material.<br>
totalprice: Automatically calculated based on quantity and price.</p>
<h5>3. Images Table (zimages_table)</h5>
<p>
<b>Purpose:</b> Manages images that are linked to materials and salers, storing metadata like image type, name, and the image data itself.<br>
<b>Key Fields:</b><br>
image_number: Unique identifier for each image.<br>
matno: Reference to the material associated with the image.<br>
salerid: Reference to the saler.<br>
attachment: Raw binary data representing the image.
</p>
<hr>

<u><h3>Key Concepts and Features</h3></u>
<h5>1.CRUD Operations:</h5>
<p>Supports full create, update, and delete operations for Salers, Materials, and Images.</p>

<h5>2.Business Logic:</h5>
<p>
<b>Material Availability:</b> Actions to set a material's status to available or unavailable.<br>
<b>Price Calculation:</b> Automatic calculation of the total price when the price or quantity of materials changes.<br>
<b>Validations:</b> Ensures correct data entry for fields like Salerid and Price.
</p>
<h5>3. Locking:</h5>
Master-level locking for Salers.<br>
Dependent locking for Materials and Images based on their association to Salers.

<h5>Associations:</h5>
<p>
  Materials are associated with Salers.<br>
Images are associated with Materials and Salers.
</p>






