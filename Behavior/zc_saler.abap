projection;
strict ( 2 );
//use draft;

define behavior for zc_Saler
{
  use create;
  use update;
  use delete;
  use action extendmat;

  use action load_material;


  use association _material { create; }
}


define behavior for zc_materials
use etag
{
  use update;
  use delete;
  use action matavailable;
  use action matnotavailable;
  use association _saler;
  use association _images { create; }
}

define behavior for zc_images
{
  use update;
  use delete;
  use association _material;
  use association _saler;
}