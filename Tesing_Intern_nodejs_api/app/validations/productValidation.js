function validateProductData({ PRODUCTNAME, PRICE, STOCK }) {
    if (!PRODUCTNAME || typeof PRODUCTNAME !== 'string' || PRODUCTNAME.trim() === '') {
        return 'Product name is required.';
    }
    if (isNaN(PRICE) || PRICE <= 0) {
        return 'Price must be a positive number.';
    }
    if (!Number.isInteger(STOCK) || STOCK < 0) {
        return 'Stock must be a non-negative integer.';
    }
    return null;
}

module.exports = {
    validateProductData,
};
