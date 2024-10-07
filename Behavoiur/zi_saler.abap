managed;
strict ( 2 );

define behavior for zi_saler //alias <alias_name>
implementation in class zbp_i_saler unique
persistent table zsalers_table
lock master
authorization master ( instance )
early numbering
{
  create;
  update;
  delete;
  field ( readonly ) SalerId;
  association _material { create; }

  mapping for zsalers_table
  {
  Address = address;
  Name = name;
  SalerId = saler_id;
  }
}

define behavior for zi_materal //alias <alias_name>
implementation in class zcl_b_materials unique
persistent table zmaterials_table
lock dependent by _saler
authorization dependent by _saler
//etag master MaterialCreatedAt
early numbering
{
  update;
  delete;
  field ( readonly ) MaterialNumber, Salerid,status;
  action matavailable result[1] $self;
  action matnotavailable result[1] $self;
  association _saler;
  association _images { create; }
  mapping for zmaterials_table
  {
  Currencycode = currencycode;
  MatType = type;
  Material = material;
  MaterialCreatedAt =  material_created_at;
  MaterialCreatedBy = material_created_by;
  MaterialNumber = material_number;
  Price = price;
  Quantity = quantity;
  Salerid = salerid;
  UnitField =  unit_field;
  status = Status;
  }
}

define behavior for zi_images //alias <alias_name>
implementation in class zcl_b_images unique
persistent table zimages_table
lock dependent by _saler
authorization dependent by _saler
early numbering
//etag master
{
  validation validate_seller on save { create; field Salerid; }
*validation validate_status on save { create; field Status; }
  validation validate_amount on save { create; field Price; }
  update;
  delete;
  field ( readonly ) ImageNumber, Matno, Salerid;
  association _material;
  ancestor  association _saler;

  mapping for zimages_table
  {
  Attachment = attachment;
  Id = id;
  ImageNumber = image_number;
  Matno = matno;
  Name = name;
  Salerid = salerid ;
  Type = type;

  }
}