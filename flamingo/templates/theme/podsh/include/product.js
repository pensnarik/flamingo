<script type="text/javascript">
    $('.ts-append').click(function() {
        updateCartItem($(this).attr('product-id'), 1);
    });

    $('.ts-oneclick').click(function() {
        var id = $(this).attr('product-id');
        $('#oc-title').html($('#product-' + id + '-title').html());
        $('#oc-product-id').val(id);
        oneClickDisplayForm();
    });
</script>