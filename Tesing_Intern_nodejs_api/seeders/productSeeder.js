// run db => node seeders/productSeeder.js

const ProductModel = require('../app/models/ProductModel');

async function seedProducts() {
    const sampleProducts = [
        { PRODUCTNAME: 'iPhone 14', PRICE: 999, STOCK: 10 },
        { PRODUCTNAME: 'Samsung Galaxy S23', PRICE: 899, STOCK: 15 },
        { PRODUCTNAME: 'Xiaomi Redmi Note 12', PRICE: 299, STOCK: 50 },
        { PRODUCTNAME: 'OnePlus 11', PRICE: 749, STOCK: 20 },
        { PRODUCTNAME: 'Google Pixel 7', PRICE: 699, STOCK: 25 },
        { PRODUCTNAME: 'Huawei P60 Pro', PRICE: 799, STOCK: 12 },
        { PRODUCTNAME: 'Oppo Find X5', PRICE: 679, STOCK: 30 },
        { PRODUCTNAME: 'Vivo X90', PRICE: 650, STOCK: 18 },
        { PRODUCTNAME: 'Realme GT Neo 5', PRICE: 549, STOCK: 22 },
        { PRODUCTNAME: 'Sony Xperia 1 IV', PRICE: 999, STOCK: 8 },
        { PRODUCTNAME: 'Asus ROG Phone 7', PRICE: 1099, STOCK: 6 },
        { PRODUCTNAME: 'Motorola Edge 40', PRICE: 599, STOCK: 14 },
        { PRODUCTNAME: 'Nokia X30', PRICE: 449, STOCK: 19 },
        { PRODUCTNAME: 'Infinix Zero 5G', PRICE: 299, STOCK: 40 },
        { PRODUCTNAME: 'Tecno Phantom X2', PRICE: 499, STOCK: 25 },
        { PRODUCTNAME: 'iPhone SE 2022', PRICE: 429, STOCK: 35 },
        { PRODUCTNAME: 'Samsung Galaxy A54', PRICE: 349, STOCK: 38 },
        { PRODUCTNAME: 'Xiaomi 13 Lite', PRICE: 399, STOCK: 27 },
        { PRODUCTNAME: 'POCO X5 Pro', PRICE: 329, STOCK: 33 },
        { PRODUCTNAME: 'Redmi 12C', PRICE: 159, STOCK: 60 },
    ];

    try {
        for (const product of sampleProducts) {
            await ProductModel.create(product);
        }
        console.log('✅ 20 Products seeded successfully.');
        process.exit(0); // Exit success
    } catch (err) {
        console.error('❌ Error seeding products:', err);
        process.exit(1); // Exit error
    }
}

seedProducts();
