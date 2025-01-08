@Metadata.layer: #CORE
@UI: {
headerInfo: {   typeName: 'Materials Data',
typeNamePlural: 'Materials Information',
            title: {
                        type:#STANDARD,
                        label: 'Materials Data',
                        value : 'Material'}

                        }
              ,
         presentationVariant: [{
         sortOrder: [{  by :'Quantity',
                        direction: #DESC }],
         visualizations: [{  type :#AS_LINEITEM }]
         }]
}
@Search.searchable: true
annotate view zc_materials with
{

  @UI.facet: [
   { id : 'MaterialDetail',
                 purpose : #STANDARD,
                 type: #COLLECTION,
                 label : 'Materials Information',
                 position : 10 } ,
    { id :  'Material',
               purpose : #STANDARD,
               type: #IDENTIFICATION_REFERENCE,
               label : 'Material Data',
               parentId: 'MaterialDetail',
               position : 10 },
    { id : 'MaterialData',
                purpose : #STANDARD,
                type: #FIELDGROUP_REFERENCE,
                parentId: 'MaterialDetail',
                label : 'Quantity and Price',
                position : 20,
                targetQualifier: 'QPMat'},
    { id : 'Images',
                 type: #LINEITEM_REFERENCE,
                 label : 'Images Information',
                 targetElement: '_images',
                 position : 20 }, 
    { id: 'GeneralData',
                purpose    : #HEADER,
                label      : 'General Information',
                type       : #FIELDGROUP_REFERENCE,
                targetQualifier: 'HeaderData',
                position: 10},
    { id: 'Rating',
                    purpose    : #HEADER,
                    label      : 'Material Rating',
                    type       : #DATAPOINT_REFERENCE,
                    targetQualifier: 'RatingStars',
                    position: 20}
  ]


  
  @UI : {
//   lineItem: [
//              { type:#FOR_ACTION, dataAction: 'load_material', label :'Load Materials', criticality:'green'}
//              ],
                     
  identification: [ 
                      { type:#FOR_ACTION, dataAction: 'matavailable', label :'Availabe', criticality:'green',position: 10},
                      { type:#FOR_ACTION, dataAction: 'matnotavailable', label :'Not Availabe', criticality:'red', position: 10}
                      ]
                   }
                   
  @Search.defaultSearchElement: true
  @UI.hidden:true
  MaterialNumber;

  @UI.fieldGroup: [{ qualifier: 'HeaderData',
                   type: #AS_CONTACT,
                   label: 'Seller',
                   position: 20,
                   value: '_saler'}]
                   
  @UI.lineItem: [{ type : #AS_CONTACT,
                   label : 'Contact',
                   value : '_saler',
                   position: 20
                     }]
  Salerid;
  @UI.hidden
  red;
  @UI.hidden
  green;
  @UI : {
  lineItem: [{ position : 20 ,
               label :'Material' },
               { type:#WITH_URL, url: 'Material' , value: 'Material'}],
  identification: [{  position : 20 ,
                      label :'Material'  }]
             }
  Material;
  @UI : { lineItem: [{ position : 30,
                       label :'Material Type' } ],
  identification: [{  position : 30,
                      label :'Material Type' }] }
  @Consumption.valueHelpDefinition: [{ entity :{
                                                  element: 'Materialtype',
                                                  name: 'zi_materialtyp_vh'},
                                                  useForValidation: true }]
  @Search.defaultSearchElement: true
  MatType;
  @UI : { lineItem: [{ position : 40,
                       label :'UnitField' }],
  identification: [{  position : 40 ,
                      label :'UnitField' }] }
  UnitField;
  @UI : { lineItem: [{ position : 50,
                       label : 'Status',
                       value :'Status',
                       criticality: 'FinalStatus' }] }
  @UI : { fieldGroup: [{ qualifier: 'HeaderData',
                            position : 60 ,
                            label :'Status',
                            value :'Status',
                            criticality: 'FinalStatus' }] } 
  FinalStatus;
  @UI : { lineItem: [{ position : 60,
                       label :'Currencycode' }],
  identification: [{  position : 60,
                      label :'Currencycode' }] }
  @Consumption.valueHelpDefinition: [{ entity :{
                                                  element: 'Currency',
                                                  name: 'I_Currency' },
                                                  useForValidation: true }]
  Currencycode;
  @UI : { lineItem: [{ position : 70 ,
                       label :'Quantity' }],
  fieldGroup: [{ qualifier: 'QPMat',
                  position : 10 ,
                  label :'Quantity' }] }
  
  Quantity;
  @UI : { lineItem: [{ position : 80 ,
                       label :'Price per Unit' }],
  fieldGroup: [{ qualifier: 'QPMat',
                 position : 20 ,
                 label :'Price per Unit' }] }
  Price;
  @UI.fieldGroup: [{ qualifier: 'HeaderData',
                 position : 40 ,
                 label :'Material Created By' }] 
  MaterialCreatedBy;
  @UI.fieldGroup: [{ qualifier: 'HeaderData',
                 position : 50 ,
                 label :'Last Changed By' }] 
  LastChangedBy;
  @UI.hidden: true
  MaterialCreatedAt;
  @UI : { lineItem: [{ position : 90 ,
                       label :'Total Amount' }],
  fieldGroup: [{ qualifier: 'QPMat',
                 position : 30 ,
                 label :'Total Amount' }] }
  TotalPrice;
  @UI : { 
  dataPoint:{ qualifier: 'RatingStars',
              targetValue: 5,
              visualization: #RATING,
              title: 'Material Rating' },
  identification: [{ label : 'Rating',
                     position : 100 }]               
            }
  Rating;
}