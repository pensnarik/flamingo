function updateCartTotals(totals, prefix)
{
    $('.cart-total-count').html(totals.quantity.toFixed(0));
    $('.cart-total-amount').html(prefix + totals.amount.toFixed(0) + '<span class="sr-only">р.</span><span class="pt-sans-forced ruble" aria-hidden="true" style="display:none;"></span></span>');
}

function updateCartItem(id, quantity)
{
    $.ajax({method: 'POST', url: '/cart/update/' + id + '?quantity=' + quantity}).done(function(data) {
        console.log(data);
        updateCartTotals(data.items[1], '');

        // items[0] - обновленная строка корзины, imtes[1] - итоги

        $('#cart-item-' + data.items[0].id + ' .item-quantity').html(data.items[0].quantity);
        $('#cart-item-' + data.items[0].id + ' .item-price').html(data.items[0].price.toFixed(2));
        $('#cart-item-' + data.items[0].id + ' .item-amount').html(data.items[0].amount.toFixed(2));
    });
}

function addToCart(id) {
    $.ajax({method: 'POST', url: '/cart/update/' + id + '?quantity=1'}).done(function(data) {
        updateCartTotals(data.items[1], '');
        console.log(data.items[0]);
        $('#preorder-product-id').val(data.items[0].product_id);
        $('#btn-preorder').attr('disabled', 'disabled');
        $('#dlg-preorder .block-danger').removeClass('visible');
        $('#dlg-preorder').modal();
    });
}

function removeProductFromCart(id)
{
    $.ajax({method: 'POST', url: '/cart/remove/' + id}).done(function(data) {
        $('#cart-item-' + data.totals.oid).fadeTo('slow', 0, function() { $(this).remove() });
        updateCartTotals({quantity: data.totals.oquantity, amount: data.totals.oamount}, '');
    });
}

function oneClickDisplayForm() {
    $('#btn-oc-order').attr('disabled', 'disabled');
    $('#dlg-one-click .block-danger').removeClass('visible');
    $('#dlg-one-click').modal();
}

$(document).ajaxError(function (event, xhr, settings, error) {
    //when there is an AJAX request and the user is not authenticated -> redirect to the login page
    if (xhr.status == 403) { // 403 - Forbidden
        window.location = '/403.html';
    }
});

var OneClickOrderDone = false;

function oneClick() {
    // To prevent multiple click
    $('#btn-oc-order').attr('disabled', 'disabled');
    var phone = $('#oc-phone').val();
    var email = $('#oc-email').val();
    var name = $('#oc-name').val();
    var product_id = $('#oc-product-id').val();

    var data = {phone: phone, email: email, name: name, product_id: product_id};

    $.ajax({method: 'POST', url: '/oneclick/' + product_id, data: data}).done(function(data) {
        if(data.status == 'error') {
            OneClickOrderDone = false;
            $('#dlg-one-click .block-danger').addClass('visible');
            $('#one-click-error-message').html(data.message);
        } else {
            OneClickOrderDone = true;
            $('#dlg-one-click').modal('hide');
        }
    }).fail(function(jqXHR, status) {
        if(jqXHR.satus == 403) {
            window.location = '/403.html';
        }
    }).always(function(data) {
        $('#btn-oc-order').removeAttr('disabled');
    });
}