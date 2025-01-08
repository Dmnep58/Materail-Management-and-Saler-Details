CLASS lhc_zi_materal DEFINITION INHERITING FROM cl_abap_behavior_handler.

    PRIVATE SECTION.
  
      METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR zi_materal RESULT result.
  
      METHODS earlynumbering_cba_Images FOR NUMBERING
        IMPORTING entities FOR CREATE zi_materal\_Images.
  
      METHODS matavailable FOR MODIFY
        IMPORTING keys FOR ACTION zi_materal~matavailable RESULT result.
  
      METHODS matnotavailable FOR MODIFY
        IMPORTING keys FOR ACTION zi_materal~matnotavailable RESULT result.
  
      METHODS get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR zi_materal RESULT result.
  
      METHODS validate_amount FOR VALIDATE ON SAVE
        IMPORTING keys FOR zi_materal~validate_amount.
  
      METHODS total_price_calc FOR DETERMINE ON MODIFY
        IMPORTING keys FOR zi_materal~Total_price_calc.
  
  *    METHODS setstatus FOR DETERMINE ON SAVE
  *      IMPORTING keys FOR zi_materal~setstatus.
      METHODS validate_quantity FOR VALIDATE ON SAVE
        IMPORTING keys FOR zi_materal~validate_quantity.
      METHODS available_status FOR DETERMINE ON MODIFY
        IMPORTING keys FOR zi_materal~available_status.
  
  
  ENDCLASS.
  
  CLASS lhc_zi_materal IMPLEMENTATION.
  
    "generate the image number and id for the images to be uploaded.
    METHOD earlynumbering_cba_Images.
      DATA: max_no TYPE zimgid.
      " read the entities by associated links
      READ ENTITIES OF zi_saler IN LOCAL MODE
              ENTITY zi_materal BY \_images
              FROM CORRESPONDING #( entities )
              LINK DATA(lt_link_images).
  
  
      " loop over all unique %tky --> for seller id and Image id
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>) GROUP BY <fs_entity>-%tky.
  
        "get the highest image id from material belonging to materials
        max_no = REDUCE #(
                      INIT lv_max = 0
                      FOR ls_image IN lt_link_images
                      USING KEY entity
                      WHERE ( source-MaterialNumber = <fs_entity>-MaterialNumber
                              AND source-Salerid = <fs_entity>-Salerid )
                      NEXT lv_max = COND zimgid(
                                       WHEN lv_max < ls_image-target-ImageNumber
                                       THEN ls_image-target-ImageNumber
                                       ELSE lv_max ) ).
  
        "get the highest image id from incoming entities
        max_no = REDUCE #(
                    INIT lv_max1 = max_no
                    FOR ls_entity IN entities
                    USING KEY entity
                    WHERE ( MaterialNumber = <fs_entity>-MaterialNumber
                              AND Salerid = <fs_entity>-Salerid )
                    FOR ls_imageid IN ls_entity-%target
                    NEXT lv_max1 = COND zimgid(
                                       WHEN lv_max1 < ls_imageid-ImageNumber
                                       THEN ls_imageid-ImageNumber
                                       ELSE lv_max1 ) ).
  
  
        "loop over all entries in entities with same Seller id and Material Id
        LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_material>)
            USING KEY entity
            WHERE MaterialNumber = <fs_entity>-MaterialNumber
            AND Salerid = <fs_entity>-Salerid.
  
          " check  in the target entity
          LOOP AT <fs_material>-%target ASSIGNING FIELD-SYMBOL(<ls_ImageId>).
            IF <ls_ImageId>-ImageNumber IS INITIAL.  " check Image number and assign the new material number to the entity
              max_no +=  1.
              APPEND CORRESPONDING #( <ls_ImageId> ) TO mapped-zi_images ASSIGNING FIELD-SYMBOL(<ls_new_ImageId>).
              <ls_new_ImageId>-ImageNumber = max_no.
            ENDIF.
          ENDLOOP.
        ENDLOOP.
      ENDLOOP.
    ENDMETHOD.
  
  
    " make the Material Available
    METHOD matavailable.
      MODIFY ENTITIES OF zi_saler IN LOCAL MODE
      ENTITY zi_materal UPDATE FIELDS ( Status )
      WITH VALUE #(  FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                             Status = 'Available' ) ).
  
      READ ENTITIES OF zi_saler IN LOCAL MODE
      ENTITY zi_materal
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).
  
      result = VALUE #( FOR ls_result IN lt_result  ( %tky = ls_result-%tky
                                                       %param = ls_result ) ).
    ENDMETHOD.
  
    " make the Material Not Available
    METHOD matnotavailable.
      MODIFY ENTITIES OF zi_saler IN LOCAL MODE
        ENTITY zi_materal UPDATE FIELDS ( Status )
        WITH VALUE #(  FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                               Status = 'Not_Available' ) ).
  
      READ ENTITIES OF zi_saler IN LOCAL MODE
      ENTITY zi_materal
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).
  
      result = VALUE #( FOR ls_result IN lt_result  ( %tky = ls_result-%tky
                                                       %param = ls_result ) ).
    ENDMETHOD.
  
    " Authorization method implemented
    METHOD get_instance_authorizations.
    ENDMETHOD.
  
    " feature control in material maintenance
    METHOD get_instance_features.
      READ ENTITIES OF zi_saler IN LOCAL MODE
       ENTITY zi_saler BY \_material
       FIELDS ( Salerid Status )
       WITH CORRESPONDING #( keys )
       RESULT DATA(lt_saler).
  
      result = VALUE #( FOR ls_saler IN lt_saler
                         ( %tky = ls_saler-%tky
                            %features-%action-matavailable = COND #( WHEN ls_saler-Status = 'Available'
                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                     ELSE if_Abap_behv=>fc-o-enabled )
                            %features-%action-matnotavailable = COND #( WHEN ls_saler-Status = 'Not_Available'
                                                                     THEN if_abap_behv=>fc-o-disabled
                                                                     ELSE if_Abap_behv=>fc-o-enabled ) ) ).
    ENDMETHOD.
  
  
    METHOD validate_amount.
  
      "read the material table for the Price.
      READ ENTITY IN LOCAL MODE zi_materal
              FIELDS ( Price )
              WITH CORRESPONDING #( keys )
              RESULT DATA(lt_price).
  
      "Check the Price.
      LOOP AT lt_price INTO DATA(ls_price).
        IF ls_price-Price EQ 0.
          APPEND VALUE #( %tky = ls_price-%tky ) TO failed-zi_materal.
          APPEND VALUE #( %tky = ls_price-%tky
                          %msg = new_message_with_text( text = 'Amount can not be equal to 0' )
                          ) TO reported-zi_materal.
        ENDIF.
        IF ls_price-Price < 0.
          APPEND VALUE #( %tky = ls_price-%tky ) TO failed-zi_materal.
          APPEND VALUE #( %tky = ls_price-%tky
                          %msg = new_message_with_text( text = 'Amount can not be less than or equal to 0' )
                          ) TO reported-zi_materal.
        ENDIF.
      ENDLOOP.
    ENDMETHOD.
  
    "calculate the total amount. --> internal action
    METHOD validate_quantity.
       READ ENTITY IN LOCAL MODE zi_materal
              FIELDS ( Quantity )
              WITH CORRESPONDING #( keys )
              RESULT DATA(lt_Qty).
  
      "Check the Quantity.
      LOOP AT lt_qty INTO DATA(ls_qty).
        IF ls_qty-Quantity <  0.
          APPEND VALUE #( %tky = ls_qty-%tky ) TO failed-zi_materal.
          APPEND VALUE #( %tky = ls_qty-%tky
                          %msg = new_message_with_text( text = 'Quantity can not be less than 0' )
                          ) TO reported-zi_materal.
        ENDIF.
        exit.
      ENDLOOP.
    ENDMETHOD.
  
    " determination calling internal action to calculate total price.
    METHOD Total_price_calc.
      READ ENTITIES OF zi_saler IN LOCAL MODE
        ENTITY zi_saler BY \_material
        FIELDS ( Price Quantity TotalPrice )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_material).
  
      LOOP AT lt_material ASSIGNING FIELD-SYMBOL(<fs_mat>).
        <fs_mat>-TotalPrice = <fs_MAT>-price * <fs_MAT>-Quantity.
      ENDLOOP.
      UNASSIGN <FS_MAT>.
      CHECK lt_material IS NOT INITIAL.
  
      MODIFY ENTITIES OF zi_saler IN LOCAL MODE
      ENTITY zi_materal
      UPDATE FIELDS ( TotalPrice )
       WITH VALUE #( FOR ls_mat IN lt_material  (
                             MaterialNumber   = ls_mat-MaterialNumber
                             Salerid = ls_mat-Salerid
                             TotalPrice  = ls_mat-TotalPrice ) ).
  
    ENDMETHOD.
  
  * Make the Status as Available when material is created.
  *  METHOD SetStatus.
  *    READ ENTITIES OF zi_SALER IN LOCAL MODE
  *    ENTITY zi_saler BY \_material
  *     FIELDS ( Status )
  *     WITH CORRESPONDING #( keys )
  *     RESULT DATA(lt_material).
  *
  *    DELETE lt_material WHERE Status IS NOT INITIAL.
  *
  *    CHECK lt_material IS NOT INITIAL.
  *
  *    MODIFY ENTITIES OF zi_saler IN LOCAL MODE
  *    ENTITY zi_materal
  *    UPDATE FIELDS ( Status )
  *    WITH VALUE #( FOR ls_mat IN lt_material ( %tky = ls_mat-%tky
  *                                               Status = 'Available'
  *                                                ) ).
  *
  *  ENDMETHOD.
  
  
    METHOD Available_status.
    READ ENTITIES OF zi_saler IN LOCAL MODE
        ENTITY zi_saler BY \_material
        FIELDS ( Quantity  TotalPrice )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_material).
  
      LOOP AT lt_material ASSIGNING FIELD-SYMBOL(<fs_mat>).
        if <fs_mat>-Quantity EQ 0 or <fs_mat>-Price eq 0.
          <fs_mat>-Status = 'Not_Available'.
          <fs_mat>-FinalStatus = 1.
         else.
          <fs_mat>-Status = 'Available'.
          <fs_mat>-FinalStatus = 3.
        endif.
      ENDLOOP.
      UNASSIGN <fs_mat>.
      CHECK lt_material IS NOT INITIAL.
  
      MODIFY ENTITIES OF zi_saler IN LOCAL MODE
      ENTITY zi_materal
      UPDATE FIELDS ( Status )
       WITH VALUE #( FOR ls_mat IN lt_material  (
                             MaterialNumber   = ls_mat-MaterialNumber
                             Salerid = ls_mat-Salerid
                             Status  = ls_mat-Status ) ).
    ENDMETHOD.
  
  
  ENDCLASS.