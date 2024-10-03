" Meta Data Extension For Image Entity

@Metadata.layer: #CORE
@UI: {
headerInfo: {   typeName: 'Images Data',
typeNamePlural: 'Saler Information',
            title: {
                        type:#STANDARD,
                        label: 'Images Data',
                        value : 'ImageNumber'}
}
}
annotate entity zc_images with
{
@UI.facet: [ { id : 'Name',
    purpose : #STANDARD,
    type: #IDENTIFICATION_REFERENCE,
    label : 'Image Information',
    position : 10 }]

@UI : { lineItem: [{ position : 10 , label :'ImageNumber' }],
identification: [{  position : 10 , label :'ImageNumber' }] }
    ImageNumber;
@UI : { lineItem: [{ position : 20 , label :'Material Number' }],
identification: [{  position : 20 , label :'Material Number' }] }
    Matno;
@UI.hidden: true
    Salerid;
@UI.hidden: true
    Id;
@UI : { lineItem: [{ position : 30 , label :'Image Type' }],
identification: [{  position : 30 , label :'Image Type' }] }
    Type;
@UI : { lineItem: [{ position  :40 , label :'Image Name' }],
identification: [{  position : 40 , label :'Image Name' }] }
    Name;
@UI : { lineItem: [{ position : 50 , label :'Attachment' }],
identification: [{  position : 50 , label :'Attachment' }] }
    Attachment;
}