" Consumption View
projection;
strict ( 2 );

define behavior for zc_Saler //alias <alias_name>
{
  use create;
  use update;
  use delete;

  use association _material { create; }
}


define behavior for zc_materials //alias <alias_name>
//use etag
{
  use update;
  use delete;
  use action matavailable;
  use action matnotavailable;
  use association _saler;
  use association _images { create; }
}

define behavior for zc_images //alias <alias_name>
{
  use update;
  use delete;

  use association _material;
  use association _saler;
}