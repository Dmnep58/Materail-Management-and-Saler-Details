-- images table
@EndUserText.label : 'images table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zimages_table {

  key image_number : zimgid not null;
  @AbapCatalog.foreignKey.screenCheck : false
  key matno        : zmatno not null
    with foreign key zmaterials_tab
      where material_number = zimages_table.matno;
  @AbapCatalog.foreignKey.screenCheck : false
  key salerid      : zsale not null
    with foreign key zsalers_tab
      where saler_id = zimages_table.salerid;
  id               : sysuuid_x16 not null;
  type             : abap.char(128);
  name             : abap.char(128);
  attachment       : abap.rawstring(0);

}


-- Materials Table

@EndUserText.label : 'materials table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zmaterials_table {

  key client          : mandt not null;
  key material_number : zmatno not null;
  @AbapCatalog.foreignKey.screenCheck : false
  key salerid         : zsale not null
    with foreign key zsalers_tab
      where saler_id = zmaterials_table.salerid;
  material            : abap.char(30);
  type                : abap.char(10);
  unit_field          : abap.unit(2);
  @Semantics.quantity.unitOfMeasure : 'zmaterials_tab.unit_field'
  quantity            : abap.quan(12,0);
  currencycode        : /dmo/currency_code;
  @Semantics.amount.currencyCode : 'zmaterials_tab.currencycode'
  price               : abap.curr(12,2);
  last_changed_by     : syuname;
  created_by          : syuname;
  material_created_at : abp_locinst_lastchange_tstmpl;
  status              : abap.char(15);
  @Semantics.amount.currencyCode : 'zmaterials_tab.currencycode'
  totalprice          : abap.curr(15,2);
  rating              : zmatrating;

}


-- Salers Data Table

@EndUserText.label : 'salers data'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zsalers_tab {

  key client    : abap.clnt not null;
  key saler_id  : zsale not null;
  name          : abap.char(40);
  phone         : telf1;
  email         : abap.char(50);
  address       : abap.char(50);
  postcode      : abap.char(10);
  lastchangedat : abp_locinst_lastchange_tstmpl;

}

-- log table 
@EndUserText.label : 'log table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zlog_tab_upd {

  key changeid     : abap.raw(16) not null;
  salerid          : zsale;
  materialid       : zmatno;
  imageid          : zimgid;
  change_operation : abap.char(10);
  changed_field    : abap.char(40);
  changed_value    : abap.char(40);
  created_at       : timestampl;

}

-- material type table
@EndUserText.label : 'material types'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zmaterial_type {

  key materialid : abap.int4 not null;
  materialname   : abap.char(20);
  materialtype   : abap.char(3);

}


