<h1>RAP Application: Materials, Salers, and Images Management</h1>
<p>This project is a RAP (RESTful ABAP Programming) application that manages materials, salers (sellers), and their associated images. <br>
The system allows users to perform CRUD (Create, Read, Update, Delete) operations on these entities and implements business logic to ensure data consistency and correct associations.</p>

<hr>
<u><h4>Table Structure</h4></u>
<h5>1. Salers Table (zsalers_table)</h5>
<p><b>Purpose:</b> Stores information about the salers (sellers) such as their ID, name, and address.<br>
<b>Key Fields:</b><br>
  <ul>
    <li>saler_id: Unique identifier for each saler.</li>
    <li>name: The name of the saler.</li>
    <li>address: Address of the saler.</li>
  </ul>
</p>

<h5>2. Materials Table (zmaterials_table)</h5>
<p><b>Purpose:</b>Purpose: Contains material-related data including material number, type, price, quantity, and the seller it is linked to.
</p>
<p><b>Key Fields:</b><br>
  <ul>
    <li>material_number: Unique identifier for each material.</li>
    <li>material: Material description.</li>
    <li>price: Price of the material.</li>
    <li>quantity: Quantity of the material in stock.</li>
    <li>salerid: Reference to the seller (saler) for the material.</li>
    <li>totalprice: Automatically calculated based on quantity and price.</li>
  </ul>
</p>
<h5>3. Images Table (zimages_table)</h5>
<p>
<b>Purpose:</b> Manages images that are linked to materials and salers, storing metadata like image type, name, and the image data itself.<br>
<b>Key Fields:</b><br>
  <ul>
    <li>image_number: Unique identifier for each image.</li>
    <li>matno: Reference to the material associated with the image.</li>
    <li>salerid: Reference to the saler.</li>
    <li>attachment: Raw binary data representing the image.</li>
  </ul>
</p>
<hr>

<u><h3>Key Concepts and Features</h3></u>
<h5>1. CRUD Operations:</h5>
<p>
  <ul>
    <li> Supports full create, update, and delete operations for Salers, Materials, and Images.</li>
  </ul>
</p>

<h5>2. Business Logic:</h5>
<p>
<ul>
  <li><b>Material Availability:</b> Actions to set a material's status to available or unavailable.</li>
  <li><b>Price Calculation:</b> Automatic calculation of the total price when the price or quantity of materials changes.</li>
  <li><b>Validations:</b> Ensures correct data entry for fields like Salerid and Price.</li>
</ul>
</p>
<h5>3. Locking:</h5>
<ul>
  <li>Master-level locking for Salers.</li>
  <li>Dependent locking for Materials and Images based on their association to Salers.</li>
</ul>


<h5>4. Associations:</h5>
<p>
<ul>
  <li>Materials are associated with Salers.</li>
  <li>Images are associated with Materials and Salers.</li>
</ul>
</p>

<h2>Output of the Application</h2>
<ul>
<li>1. Main Page</li>
<img src =' https://github.com/user-attachments/assets/1f5541e8-6d29-416c-850a-e96016e0ca73'/>
<li>2. Secondary Seller object page and list page.</li>
<img src = 'https://github.com/user-attachments/assets/cfaafaa8-07e6-4f03-8adc-f692f43e4dc3'/>
<li>3. More detailed with material object page and image list view.</li>
<img src = 'https://github.com/user-attachments/assets/f415128b-1489-4541-859c-f9f06ecad06c'/>
</ul>




