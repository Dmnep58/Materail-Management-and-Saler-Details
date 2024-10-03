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
    with foreign key zsalers_table
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

key material_number : zmatno not null;
@AbapCatalog.foreignKey.screenCheck : false
key salerid         : zsale not null
    with foreign key zsalers_table
    where saler_id = zmaterials_table.salerid;
material            : abap.char(30);
type                : abap.char(10);
unit_field          : abap.unit(2);
@Semantics.quantity.unitOfMeasure : 'zmaterials_tab.unit_field'
quantity            : abap.quan(12,0);
currencycode        : /dmo/currency_code;
@Semantics.amount.currencyCode : 'zmaterials_tab.currencycode'
material_created_by : abap.char(40);
price               : abap.curr(12,2);
material_created_at : abp_locinst_lastchange_tstmpl;
status              : abap.char(2);
}


-- Salers Data Table

@EndUserText.label : 'salers data'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zsalers_table {

key saler_id : zsale not null;
name         : abap.char(40);
address      : abap.char(50);

}