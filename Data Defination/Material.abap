" Materials data definition.

" Interface View --> Base View

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view of material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_materal as select from zmaterials_table
association to parent zi_saler as _saler on $projection.Salerid = _saler.SalerId
composition [0..*] of zi_images as _images
{
    key material_number                                             as MaterialNumber,
    key salerid                                                     as Salerid,
        material                                                    as Material,
        type                                                        as MatType,
        unit_field                                                  as UnitField,
        @Semantics.quantity.unitOfMeasure : 'UnitField'
        quantity                                                    as Quantity,
        currencycode                                                as Currencycode,
        @Semantics.amount.currencyCode : 'Currencycode'
        price                                                       as Price,
        material_created_by                                         as MaterialCreatedBy,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        material_created_at                                         as MaterialCreatedAt,
        status                                                      as Status,
        @Semantics.amount.currencyCode : 'Currencycode'
        totalprice                                                  as TotalPrice,
        _saler,
        @Semantics.amount.currencyCode : 'Currencycode'
        cast (price as abap.fltp ) * cast ( quantity as abap.fltp ) as TotalAmount,
        _images
}


" Consumption View --> Projection View

@EndUserText.label: 'consumption (projection) materials'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity zc_materials
    as projection on zi_materal
{
    key MaterialNumber,
    key Salerid,
    Material,
    MatType,
    UnitField,
    Quantity,
    Currencycode,
    Price,
    MaterialCreatedBy,
    MaterialCreatedAt,
    Status,
    TotalPrice,
    TotalAmount,
    /* Associations */
    _saler : redirected to parent zc_Saler,
    _images : redirected to composition child zc_images
}
