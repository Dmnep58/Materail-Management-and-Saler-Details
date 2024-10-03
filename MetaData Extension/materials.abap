"MetaData Extension for Materials Entity

@Metadata.layer: #CORE
@UI: {
headerInfo: {   typeName: 'Materials Data',
typeNamePlural: 'Materials Information',
            title: {
                        type:#STANDARD,
                        label: 'Materials Data',
                        value : 'Material'}
}
}
@Search.searchable: true
annotate view zc_materials with
{
@UI.facet: [ { id : 'Material',
    purpose : #STANDARD,
    type: #IDENTIFICATION_REFERENCE,
    label : 'Materials Information',
    position : 10 },
    { id : 'Images',
    type: #LINEITEM_REFERENCE,
    label : 'Images Information',
    targetElement: '_images',
    position : 20 }]

@UI : { lineItem: [{ position : 10 , label :'Material ids' },
        { type:#FOR_ACTION, dataAction: 'matavailable', label :'Availabe' },
        { type:#FOR_ACTION, dataAction: 'matnotavailable', label :'Not Availabe' }],
identification: [{  position : 10 , label :'Materials ids' },
        { type:#FOR_ACTION, dataAction: 'matavailable', label :'Availabe' },
        { type:#FOR_ACTION, dataAction: 'matnotavailable', label :'Not Availabe' }] }
@Search.defaultSearchElement: true
    MaterialNumber;
@UI.hidden: true
    Salerid;
@UI : { lineItem: [{ position : 30 , label :'Material' }],
identification: [{  position : 30 , label :'Material' }] }
    Material;
@UI : { lineItem: [{ position : 40 , label :'Material Type' }],
identification: [{  position : 40 , label :'Material Type' }] }
    MatType;
@UI : { lineItem: [{ position : 50 , label :'UnitField' }],
identification: [{  position : 50 , label :'UnitField' }] }
    UnitField;
@UI : { lineItem: [{ position : 60 , label :'Quantity' }],
identification: [{  position : 60 , label :'Quantity' }] }
    Quantity;
@UI : { lineItem: [{ position : 70 , label :'Currencycode' }],
identification: [{  position : 70, label :'Currencycode' }] }
    Currencycode;
@UI : { lineItem: [{ position : 80 , label :'Price' }],
identification: [{  position : 80 , label :'Price' }] }
    Price;
@UI.hidden: true
    MaterialCreatedBy;
@UI.hidden: true
    MaterialCreatedAt;
@UI : { lineItem: [{ position : 80 , label :'Status' }],
identification: [{  position : 80 , label :'Status' }] }
    Status;
}