CLASS lhs_zi_saler DEFINITION  INHERITING FROM cl_abap_behavior_saver.
    PROTECTED SECTION.
      METHODS : save_modified REDEFINITION.
  ENDCLASS.
  
  CLASS lhs_zi_saler IMPLEMENTATION.
  
    METHOD save_modified.
      DATA : lt_log TYPE STANDARD TABLE OF zlog_tab_upd.
      DATA : lt_log_c TYPE STANDARD TABLE OF zlog_tab_upd.
  *-----------------------------------------------------------------------
  * update the log when we create a seller information
  *-----------------------------------------------------------------------
  
      IF create-zi_saler IS NOT INITIAL.
        lt_log = CORRESPONDING #( create-zi_saler ).
  
        LOOP AT lt_log ASSIGNING FIELD-SYMBOL(<lfs_log>).
          GET TIME STAMP FIELD  <lfs_log>-created_at.
  
          READ TABLE create-zi_saler ASSIGNING FIELD-SYMBOL(<lfs_create>) WITH TABLE KEY entity
                                                                          COMPONENTS   SalerId = <lfs_log>-salerid.
          IF sy-subrc IS INITIAL.
  *        If Sales is created
            IF <lfs_create>-%control-SalerId = cl_abap_behv=>flag_changed.
              <lfs_log>-changed_field = 'Saler ID'.
              <lfs_log>-change_operation = 'Created'.
              <lfs_log>-changed_value = <lfs_create>-SalerId.
              TRY.
                  <lfs_log>-changeid = cl_system_uuid=>create_uuid_x16_static(  ).
                CATCH cx_uuid_error.
              ENDTRY.
              APPEND <lfs_log> TO lt_log_c.
            ENDIF.
          ENDIF.
          UNASSIGN <lfs_create>.
        ENDLOOP.
        UNASSIGN <lfs_log>.
      ENDIF.
  *-----------------------------------------------------------------------
  * update the log when we Delete a seller information
  *-----------------------------------------------------------------------
      IF delete-zi_saler IS NOT INITIAL.
        lt_log = CORRESPONDING #( delete-zi_saler ).
  
        LOOP AT lt_log ASSIGNING <lfs_log>.
          <lfs_log>-change_operation = 'Deletion'.
          GET TIME STAMP FIELD  <lfs_log>-created_at.
  
  *      If Sales is Deleted
          <lfs_log>-changed_field = 'Saler ID'.
          <lfs_log>-changed_value = <lfs_log>-SalerId.
          TRY.
              <lfs_log>-changeid = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.
          ENDTRY.
          APPEND <lfs_log> TO lt_log_c.
  
        ENDLOOP.
        UNASSIGN : <lfs_log>.
      ENDIF.
  *-----------------------------------------------------------------------
  * update the log when we Update a seller information
  *-----------------------------------------------------------------------
      IF update-zi_saler IS NOT INITIAL.
        lt_log = CORRESPONDING #( update-zi_saler ).
  
        LOOP AT update-zi_saler ASSIGNING FIELD-SYMBOL(<lfs_update>).
          ASSIGN lt_log[ salerid = <lfs_update>-SalerId ] TO <lfs_log>.
  
          <lfs_log>-change_operation = 'Updated' ##NO_TEXT.
          GET TIME STAMP FIELD  <lfs_log>-created_at.
  
  *      If Name of seller is Updated
          IF <lfs_update>-%control-Name = if_abap_behv=>mk-on.
            <lfs_log>-changed_field = 'Name'.
            <lfs_log>-changed_value = <lfs_update>-Name.
            TRY.
                <lfs_log>-changeid = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
            ENDTRY.
            APPEND <lfs_log> TO lt_log_c.
          ENDIF.
  
  *      If Address of seller is Updated
          IF <lfs_update>-%control-Address = if_abap_behv=>mk-on.
            <lfs_log>-changed_field = 'Address'.
            <lfs_log>-changed_value = <lfs_update>-Address.
            TRY.
                <lfs_log>-changeid = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
            ENDTRY.
            APPEND <lfs_log> TO lt_log_c.
          ENDIF.
  
        ENDLOOP.
        UNASSIGN : <lfs_log>, <lfs_update>.
      ENDIF.
  *      insert the log data to the table
      INSERT zlog_tab_upd FROM TABLE @lt_log_C.
  
  
  * -----------------------------------------------------------------------------------------------------
  *  Unmanaged Save for Image entity
  * -----------------------------------------------------------------------------------------------------
      IF create-zi_images IS NOT INITIAL.
        DATA : lt_images TYPE STANDARD TABLE OF zimages_table,
               ls_return TYPE bapiret2.
  
        lt_images = CORRESPONDING #( create-zi_images MAPPING image_number = ImageNumber
                                                              attachment = ImageAttachment
                                                              id = Id
                                                              matno = Matno
                                                              salerid = Salerid
                                                              name = ImageName ).
  
  *      CALL FUNCTION 'ZIMAGES_CUD' DESTINATION 'NONE'
  *        EXPORTING
  *          createx = 'X'
  *          values  = lt_images
  *        IMPORTING
  *          return  = ls_return.
        INSERT zimages_table FROM  TABLE @lt_images.
  
  
      ENDIF.
  
      IF update-zi_images IS NOT INITIAL.
        lt_images = CORRESPONDING #( update-zi_images MAPPING image_number = ImageNumber
                                                              attachment = ImageAttachment
                                                              id = Id
                                                              matno = Matno
                                                              salerid = Salerid
                                                              name = ImageName ).
        UPDATE zimages_table  FROM  TABLE @lt_images.
      ENDIF.
  
      IF delete-zi_images IS NOT INITIAL.
        lt_images = CORRESPONDING #( delete-zi_images MAPPING image_number = ImageNumber
                                                              matno = Matno
                                                              salerid = Salerid ).
  
        DELETE zimages_table FROM TABLE @lt_images.
      ENDIF.
  
    ENDMETHOD.
  
  ENDCLASS.
  
  
  
  CLASS lhc_zi_saler DEFINITION INHERITING FROM cl_abap_behavior_handler.
    PRIVATE SECTION.
  
      METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR zi_saler RESULT result.
      METHODS extendmat FOR MODIFY
        IMPORTING keys FOR ACTION zi_saler~extendmat RESULT result.
      METHODS get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR zi_saler RESULT result.
  
      METHODS load_material FOR MODIFY
        IMPORTING keys FOR ACTION zi_saler~load_material RESULT result.
  
      METHODS generate_sellerID FOR NUMBERING
        IMPORTING entities FOR CREATE zi_saler.
  
      METHODS generate_materialID FOR NUMBERING
        IMPORTING entities FOR CREATE zi_saler\_material.
  
  
  ENDCLASS.
  
  CLASS lhc_zi_saler IMPLEMENTATION.
  
    METHOD get_instance_authorizations.
    ENDMETHOD.
  
    METHOD generate_SellerId.
      "table reference.
      DATA(lt_entities) = entities.
      " check and delete the entities where the seller id is not initial.
      DELETE lt_entities WHERE SalerId IS NOT INITIAL.
      " get the next number as per the number range object created for that BO.
      TRY.
          cl_numberrange_runtime=>number_get(
          EXPORTING
           nr_range_nr = '01' " add by 1
           object = '/DMO/TRV_M' "number range Object.
           quantity = CONV #( lines( lt_entities ) ) " no of instances
         IMPORTING
           number = DATA(lv_seller_id) "new seller id
           returncode = DATA(lv_code)
           returned_quantity = DATA(lv_qty)
          ).
        CATCH cx_nr_object_not_found.
        CATCH cx_number_ranges INTO DATA(lo_error).
  
          "Find the failed and reported cases.
          LOOP AT lt_entities INTO DATA(ls_entities).
            "if failed
            APPEND VALUE #( %cid = ls_entities-%cid
                            %key = ls_entities-%key )
                            TO failed-zi_saler.
            " if reported
            APPEND VALUE #( %cid = ls_entities-%cid
                            %key = ls_entities-%key )
                            TO reported-zi_saler.
          ENDLOOP.
          EXIT.
      ENDTRY.
  
      " assertion
      ASSERT lv_qty = lines( lt_entities ).
      DATA(lv_curr_sellerid) = lv_seller_id - lv_qty.
  
      LOOP AT lt_entities INTO ls_entities.
        lv_curr_sellerid = lv_curr_sellerid + 1.
  
        APPEND VALUE #( %cid = ls_entities-%cid
                        salerid = lv_curr_sellerid )
                        TO mapped-zi_saler.
      ENDLOOP.
  
    ENDMETHOD.
  
    " generate the material id based on the seller id.
    METHOD generate_materialID.
      DATA: max_no TYPE zmatno.
  
      " read the entities by associated links
      READ ENTITIES OF zi_saler IN LOCAL MODE
   ENTITY zi_saler BY \_material
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_link_data).
  
      " loop over all unique %tky --> for seller id and material id
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>) GROUP BY <fs_entity>-SalerId.
  
        "get the highest material id
        max_no = REDUCE zbookallotids(
                      INIT lv_max = 0
                      FOR ls_link IN lt_link_data
                      USING KEY entity
                      WHERE ( source-SalerId = <fs_entity>-SalerId )
                      NEXT lv_max = COND zmatno(
                                       WHEN lv_max < ls_link-target-MaterialNumber
                                       THEN ls_link-target-MaterialNumber
                                       ELSE lv_max ) ).
  
        "get the highest material id from incoming entities
        max_no = REDUCE zbookallotids(
                    INIT lv_max1 = max_no
                    FOR ls_entity IN entities
                    USING KEY entity
                    WHERE ( SalerId = <fs_entity>-SalerId )
                    FOR ls_sellerid IN ls_entity-%target
                    NEXT lv_max1 = COND zmatno(
                                       WHEN lv_max1 < ls_sellerid-MaterialNumber
                                       THEN ls_sellerid-MaterialNumber
                                       ELSE lv_max1 ) ).
  
  
        " get the entities using seller id
        LOOP AT entities ASSIGNING FIELD-SYMBOL(<fls_entities>)
            USING KEY entity
            WHERE SalerId = <fs_entity>-SalerId.
  
          " check  in the target entity
          LOOP AT <fls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_materialId>).
            IF <ls_materialId>-MaterialNumber IS INITIAL.  " check material number and assign the new material number to the entity
              max_no +=  1.
              APPEND CORRESPONDING #( <ls_materialId> ) TO mapped-zi_materal ASSIGNING FIELD-SYMBOL(<ls_new_materialId>).
              <ls_new_materialId>-MaterialNumber = max_no.
            ENDIF.
          ENDLOOP.
        ENDLOOP.
        UNASSIGN <fls_entities>.
      ENDLOOP.
      UNASSIGN <fs_entity>.
  
    ENDMETHOD.
  
    METHOD extendmat.
    ENDMETHOD.
  
    METHOD get_instance_features.
    ENDMETHOD.
  
    METHOD load_material.
  
    ENDMETHOD.
  
  ENDCLASS.