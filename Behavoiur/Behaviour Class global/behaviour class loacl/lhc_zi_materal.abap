CLASS lhc_zi_materal DEFINITION INHERITING FROM cl_abap_behavior_handler.
    PRIVATE SECTION.
    METHODS earlynumbering_cba_Images FOR NUMBERING
        IMPORTING entities FOR CREATE zi_materal\_Images.

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
                            and source-Salerid = <fs_entity>-Salerid )
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
                                and Salerid = <fs_entity>-Salerid )
                        FOR ls_imageid IN ls_entity-%target
                        NEXT lv_max1 = COND zimgid(
                                        WHEN lv_max1 < ls_imageid-ImageNumber
                                        THEN ls_imageid-ImageNumber
                                        ELSE lv_max1 ) ).

            "loop over all entries in entities with same Seller id and Material Id
            LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_material>)
                USING KEY entity
                WHERE MaterialNumber = <fs_entity>-MaterialNumber
                and Salerid = <fs_entity>-Salerid.
    
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

ENDCLASS.