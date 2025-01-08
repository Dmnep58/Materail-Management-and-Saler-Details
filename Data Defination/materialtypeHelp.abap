" interface view for material type value help

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'value help for material type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #M,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity zi_materialtyp_vh
  as select from zmaterial_type
{
  key materialid   as Materialid,
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.8
      materialname as Materialname,
      @ObjectModel.text.element: [ 'Materialname' ]
      materialtype as Materialtype
}
