# Update product price

```bash
curl -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer 8c44548132aa16adfd953504e9b92db8" http://127.0.0.1:5000/api/set_price -d '{"sku": "1", "price": 1.0}'
```

# Get product ID by SKU

```bash
curl -i -H "Content-Type: application/json" -H "Authorization: Bearer 8c44548132aa16adfd953504e9b92db8" http://127.0.0.1:5000/api/get_product_id/nokia-101
```

# Update product name

```bash
curl -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer 8c44548132aa16adfd953504e9b92db8" http://127.0.0.1:5000/api/product/nokia-001/set_name -d '{"name": "Nokia 101 Dual SIM Black"}'
```

# Update product attributes

```
curl -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer 8c44548132aa16adfd953504e9b92db8" http://127.0.0.1:5000/api/product/nokia-001/attributes -d '{"attributes": [{"category": "Характеристики АКБ", "name": "Емкость", "value": "800 mAh"}, {"category": "Основные", "name": "Тип", "value": "Смартфон"}]}'
```

```json
{
    "attributes": [{"category": "Характеристики АКБ", "name": "Емкость", "value": "800 mAh"}]
}
```

# Update/add product

```
{
    "product": {
        "sku": "nokia-101",
        "name": "Nokia 101 Dual SIM Black",
        "manufacturer": "Nokia",
        "description": "Product description",
        "attributes": [
            {"category": "Battery", "name": "Capacity", "value": "800 mAh"}
        ],
        "images": [...]
    },
}
```

How to extract one or few products from Parsing Database.

```bash
./pdbexport.py --project-id 11 --sku 'BL-5CT' | curl -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer 8c44548132aa16adfd953504e9b92db8" http://127.0.0.1:5000/api/product/bl-5ct/set -d @-
```

```bash
for sku in `psql -tc 'select sku from product where project_id = 9' $PARSINGDB`
do
    ./pdbexport.py --project-id 9 --sku "$sku" | curl -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer 8c44548132aa16adfd953504e9b92db8" "http://127.0.0.1:5000/api/product/$sku/set" -d @-
done
```

# Export product in JSON format

```bash
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer 8c44548132aa16adfd953504e9b92db8" "http://127.0.0.1:5000/api/product/nokia-001" > nokia-001.json
```

You can use the last two API methods in order to copy a product from one shop to another one:

```bash
curl -s -H "Content-Type: application/json" -H "Authorization: Bearer 8c44548132aa16adfd953504e9b92db8" "http://127.0.0.1:5000/api/product/nokia-001" | curl -i -X POST -H "Content-Type: application/json" -H "Authorization: Bearer 8c44548132aa16adfd953504e9b92db8" "http://127.0.0.1:5000/api/product/nokia-001-copy/set" -d @-
```
