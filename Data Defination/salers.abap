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

define root view entity zi_saler
  as select from zsalers_tab
  composition [0..*] of zi_materal as _material
{
      @ObjectModel.text.element: ['Name']
  key saler_id as SalerId,
      @Semantics.name.fullName: true
      name     as Name,
      @Semantics.telephone.type: [#HOME]
      phone    as Phone,
      @Semantics.eMail.address
      email    as Email,
      @Semantics.address.zipCode: true
      postcode as Postcode,
      @Semantics.address.label: true
      address  as Address,
      lastchangedat as LastChangedAt,
      _material // Make association public
}




"consumption VIew --> projection View

@EndUserText.label: 'consumption (projection) salers'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity zc_Saler 
provider contract transactional_query
as projection on zi_saler
{
    key SalerId,
    Name,
    Phone,
    Email,
    Address,
    Postcode,
    /* Associations */
    _material : redirected to composition child zc_materials
}

