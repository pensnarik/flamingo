<script type="text/javascript">

function setPrice(product_id, price, previous_price) {
    $.ajax({method: 'POST', url: '/admin/product/' + product_id + '/set_price',
            data: {price: price}}).done(function(data) {
                console.log('Price updated successfully');
            });
    $.ajax({method: 'POST', url: '/admin/product/' + product_id + '/set_previous_price',
            data: {previous_price: previous_price}}).done(function(data) {
                console.log('Previous price updated successfully');
            });
}

function setAvailable(product_id, available) {
    $.ajax({method: 'POST', url: '/admin/product/' + product_id + '/set_available',
            data: {available: available}}).done(function(data) {
                console.log('Available updated successfully');
            });
}

function deleteImage(product_id, image_id) {
    $.ajax({method: 'POST', url: '/admin/product/' + product_id + '/image/delete',
            data: {'image_id': image_id}}).done(function(data) {
                console.log(data);
                window.location.reload();
            });
}

$('.btn-translate').click(function(event) {
    translate($(this).attr('data-id'));
});

function translate(id) {
    var original = $('#translation-' + id).html();
    console.log(original);
    var div = $('<div class="input-group"></div>');
    var input = $('<input id="input-' + id + '" type="text" class="form-control" value="' + original + '"/><span class="input-group-btn"><button onclick="doTranslate(' + id + ');" class="btn btn-default" type="button"><span class="glyphicon glyphicon-save"></span>&nbsp;OK</button>');
    $('#translation-' + id).html(div.append(input));
}

function doTranslate(id)
{
    var original = $('#original-' + id).html();
    var translation = $('#input-' + id).val();

    var data = {original: original, translation: translation, id: id};
    $.ajax({method: 'POST', url: '/admin/add_translation', data: data}).done(function(data) {
        console.log(data);
        $('#translation-' + id).html(data.translation);
    });
}

function setDeliveryCost(order_id, delivery_cost) {
    data = {order_id: order_id, delivery_cost: delivery_cost};
    $.ajax({method: 'POST', url: '/admin/order/set_delivery_cost', data: data}).done(function(data) {
        alert('OK');
    });
}

function confirmOrder(order_id) {
    $.ajax({method: 'POST', url: '/admin/order/confirm', data: {order_id: order_id}}).done(function(data) {
        alert('OK');
    });
}

$('#btn-confirm-order').click(function(event) {
    order_id = $(this).attr('data-order-id');
    confirmOrder(order_id);
})

$('#btn-update-delivery-cost').click(function(event) {
    order_id = $(this).attr('data-order-id');
    cost = $('input[name="delivery_cost"]').val();
    setDeliveryCost(order_id, cost);
});

$('#btn-update-translations').click(function(event) {
    $.ajax({method: 'POST', url: '/admin/update_translations'}).done(function(data) {
        alert(data.count + ' слов обновлено');
    });
});

</script>