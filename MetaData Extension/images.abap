@Metadata.layer: #CORE
@UI: {
headerInfo: {   typeName: 'Images Data',
            title: {
                      type:#STANDARD,
                      value : 'ImageName'
                     },
           description :{ value:'ImageNumber' }
         }
}
annotate entity zc_images with
{
  @UI.facet: [
            {   id: 'ImageDetail',
                     label : 'Image Related Data',
                     type : #IDENTIFICATION_REFERENCE,
                     purpose : #STANDARD,
                     position : 10 }

    ]
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
  @UI.hidden: true
  @UI.defaultValue: 'JPG'
  ImageType;
  @UI : { lineItem: [{ position  :30 , label :'Image Name' }] ,
        identification: [{  position : 30 , label :'Image Name' }]  }
  ImageName;

  @UI :{  lineItem: [{ label :'Attachment', position  : 40  }],
        identification: [{  position : 40 , label :'Attachment' }]  }
  ImageAttachment;

}
