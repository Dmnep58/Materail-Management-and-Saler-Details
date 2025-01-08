managed implementation in class zbp_i_saler unique;
strict ( 2 );
//with draft;

define behavior for zi_saler
implementation in class zbp_i_saler unique
persistent table zsalers_tab
with additional save
lock master
//total etag lastchangedat
authorization master ( instance )
early numbering
{

  create;
  update;
  delete;
  field ( readonly ) SalerId;
  field ( mandatory ) Name, Phone, Email;
  action extendmat parameter zmat_rating_upd result [1] $self;
  action ( features : instance ) load_material result [1] $self;

  association _material { create; }

  mapping for zsalers_tab
    {
      Address  = address;
      Name     = name;
      Phone    = phone;
      Email    = email;
      Postcode = postcode;
      SalerId  = saler_id;
    }
}

define behavior for zi_materal
implementation in class zcl_b_materials unique
persistent table zmaterials_table
lock dependent by _saler
authorization dependent by _saler
etag master MaterialCreatedAt
early numbering
{
  field ( readonly  ) MaterialNumber, Salerid, TotalPrice, Status;
  field ( readonly : update ) Material;
  field ( mandatory ) Price, Quantity;
  action ( features : instance ) matavailable result [1] $self;
  action ( features : instance ) matnotavailable result [1] $self;

  validation validate_amount on save { create; update; field Price; }
  validation validate_quantity on save { create; update; field Quantity; }
  //  if we change the field price and qunaity then only this determination will trigger
  determination Total_price_calc on modify { create; field Quantity, Price; }
  determination Available_status on modify { create; field Quantity; }
  update;
  delete;
  association _saler;
  association _images { create; }


  mapping for zmaterials_table
    {
      Currencycode      = currencycode;
      MatType           = type;
      Material          = material;
      MaterialCreatedAt = material_created_at;
      LastChangedBy     = last_changed_by;
      MaterialCreatedBy = created_by;
      MaterialNumber    = material_number;
      Price             = price;
      Quantity          = quantity;
      Salerid           = salerid;
      UnitField         = unit_field;
      status            = Status;
      TotalPrice        = totalprice;
      Rating            = rating;
    }
}

define behavior for zi_images
implementation in class zcl_b_images unique
with unmanaged save
lock dependent by _saler
authorization dependent by _saler
early numbering
{
  update;
  delete;
  field ( readonly ) ImageNumber, Matno, Salerid;
  association _material;
  ancestor association _saler;

}