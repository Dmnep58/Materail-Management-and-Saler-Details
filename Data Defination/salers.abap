" Salers data definition.

" interface view --> base View
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'salers details'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_saler as select from zsalers_table
composition[1..*] of zi_materal  as _material
{
    key saler_id as SalerId,
    name as Name,
    address as Address,
    _material // Make association public
}



"consumption VIew --> projection View

@EndUserText.label: 'consumption (projection) salers'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity zc_Saler
provider contract transactional_query
as projection on zi_saler
{
    key SalerId,
    Name,
    Address,
    /* Associations */
    _material : redirected to composition child zc_materials
}
