@Metadata.layer: #CORE
@UI: {
headerInfo: {   typeName: 'Saler Data',
typeNamePlural: 'Seller Information',
            title: {
                        type:#STANDARD,
                        label: 'Seller Data',
                        value : 'Name'},
            description : { 
                            value : 'SalerId',
                             label: 'Name'}
}
}
@Search.searchable: true
annotate view zc_Saler with
{
  @UI.facet: [ { id : 'SalerId',
    purpose : #STANDARD,
   type: #IDENTIFICATION_REFERENCE,
   label : 'Seller Information',
   position : 10 },
    { id : 'Material',
                type: #LINEITEM_REFERENCE,
                label : 'Materials Information',
                targetElement: '_material',
                position : 20 }
                ]
 
 

  @UI : { lineItem: [{ position : 10 , label :'Seller Id' },
                      { type: #FOR_ACTION,  dataAction: 'extendmat' , label: 'Update Email'} ],
  identification: [{  position : 10 , label :'Seller Id' },
                         { type:#FOR_ACTION, dataAction: 'load_material', label :'Load Materials'}]}
  @Search.defaultSearchElement: true
  SalerId;
  @UI : { lineItem: [{ position : 20 , label :'Name' }],
  identification: [{  position : 20 , label :'Name' }] }
  Name;
    @UI : { lineItem: [{ position : 30 , label :'Phone' }],
  identification: [{  position : 30 , label :'Phone' }] }
  Phone;
    @UI : { lineItem: [{ position : 40 , label :'Email' }],
  identification: [{  position : 40 , label :'Email' }] }
  Email;
  @UI : { lineItem: [{ position : 50 , label :'Address' }],
  identification: [{  position : 50 , label :'Address' }] }
  Address;
  @UI : { lineItem: [{ position : 60 , label :'Postcode' }],
  identification: [{  position : 60 , label :'Postcode' }] }
  Postcode;
  

}