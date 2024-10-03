"MetaData Extension for Salers Entity
@Metadata.layer: #CORE
@UI: {
headerInfo: {   typeName: 'Saler Data',
typeNamePlural: 'Saler Information',
            title: {
                        type:#STANDARD,
                        label: 'Saler Data',
                        value : 'SalerId'}
}
}
@Search.searchable: true
annotate view zc_Saler with
{
@UI.facet: [ { id : 'SalerId',
    purpose : #STANDARD,
    type: #IDENTIFICATION_REFERENCE,
    label : 'Saler Information',
    position : 10 },
    { id : 'Material',
                type: #LINEITEM_REFERENCE,
                label : 'Materials Information',
                targetElement: '_material',
                position : 20 }]

@UI : { lineItem: [{ position : 10 , label :'Saler Id' }],
identification: [{  position : 10 , label :'Saler Id' }] }
@Search.defaultSearchElement: true
    SalerId;
@UI : { lineItem: [{ position : 20 , label :'Name' }],
identification: [{  position : 20 , label :'Name' }] }
    Name;
@UI : { lineItem: [{ position : 30 , label :'Address' }],
identification: [{  position : 30 , label :'Address' }] }
    Address;

}