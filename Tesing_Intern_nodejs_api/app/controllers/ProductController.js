const ProductModel = require('../models/ProductModel');
const { validateProductData } = require('../validations/productValidation');

module.exports = {
    // GET /products
    async index(req, res) {
        try {
            const products = await ProductModel.getAll();
            res.status(200).json({
                success: true, message: 'Products found successfully',
                data: products,
            });
        } catch (err) {
            console.error(err);
            res.status(500).json({ success: false, message: 'Server error' });
        }
    },

    // GET /products/:id
    async show(req, res) {
        try {
            const product = await ProductModel.getById(req.params.id);
            if (!product) {
                return res.status(404).json({ success: false, message: 'Product not found' });
            }
            res.status(200).json({
                success: true,
                message: 'Product found successfully',
                data: product
            });
        } catch (err) {
            console.error(err);
            res.status(500).json({ success: false, message: 'Server error' });
        }
    },

    // POST /products
    async store(req, res) {
        try {
            const { PRODUCTNAME, PRICE, STOCK } = req.body;
            const error = validateProductData({ PRODUCTNAME, PRICE, STOCK });
            if (error) {
                return res.status(400).json({ success: false, message: error });
            }

            const newProduct = await ProductModel.create({ PRODUCTNAME, PRICE, STOCK });
            res.status(201).json({
                success: true,
                message: 'Product created successfully',
                data: newProduct
            });
        } catch (err) {
            console.error(err);
            res.status(500).json({ success: false, message: 'Server error' });
        }
    },

    // PUT /products/:id
    async update(req, res) {
        try {
            const { PRODUCTNAME, PRICE, STOCK } = req.body;
            const { id } = req.params;

            const error = validateProductData({ PRODUCTNAME, PRICE, STOCK });
            if (error) {
                return res.status(400).json({ success: false, message: error });
            }

            const updated = await ProductModel.update(id, { PRODUCTNAME, PRICE, STOCK });
            if (!updated) {
                return res.status(404).json({ success: false, message: 'Product not found or not updated' });
            }

            res.json({
                success: true,
                message: 'Product updated successfully',
                data: updated
            });
        } catch (err) {
            console.error(err);
            res.status(500).json({ success: false, message: 'Server error' });
        }
    },

    // DELETE /products/:id
    async destroy(req, res) {
        try {
            const product = await ProductModel.getById(req.params.id);

            if (!product) {
                return res.status(404).json({ success: false, message: 'Product not found' });
            }

            await ProductModel.delete(req.params.id);

            return res.json({
                success: true,
                message: 'Product deleted successfully',
                data: product
            });
        } catch (err) {
            console.error(err);
            res.status(500).json({ success: false, message: 'Server error:', error: err.message });
        }
    }

};
