" Images data definition.

" Interface VIew --> Base View
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'images tables'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_images as select from zimages_table
association to parent zi_materal as _material on  $projection.Salerid = _material.Salerid
and $projection.Matno   = _material.MaterialNumber
association [1..1] to zi_saler as _saler    on  $projection.Salerid = _saler.SalerId
{
    key image_number as ImageNumber,
    key matno as Matno,
    key salerid as Salerid,
    id as Id,
    type as Type,
    @Semantics.mimeType: true
    name as Name,
    @Semantics.largeObject :{
        mimeType: 'Type',
        fileName: 'Name',
        contentDispositionPreference: #INLINE,
        acceptableMimeTypes: ['application/pdf']
    }
    attachment as Attachment,
    _material,
    _saler
}



" consumption view --> projection View

@EndUserText.label: 'consumption (projection) images'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity zc_images as projection on zi_images
{
    key ImageNumber,
    key Matno,
    key Salerid,
    Id,
    Type,
    Name,
    Attachment,
    /* Associations */
    _material : redirected to parent zc_materials,
    _saler :  redirected to zc_Saler
}