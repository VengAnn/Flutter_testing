const { getPool, sql } = require('../../config/db');

module.exports = {
    async getAll() {
        const pool = await getPool();
        const result = await pool.request().query('SELECT * FROM PRODUCTS ORDER BY PRODUCTID DESC');
        return result.recordset;
    },

    async getById(id) {
        const pool = await getPool();
        const result = await pool.request()
            .input('id', sql.Int, id)
            .query('SELECT * FROM PRODUCTS WHERE PRODUCTID = @id');
        return result.recordset[0];
    },

    async create({ PRODUCTNAME, PRICE, STOCK }) {
        const pool = await getPool();
        const result = await pool.request()
            .input('PRODUCTNAME', sql.NVarChar(100), PRODUCTNAME)
            .input('PRICE', sql.Decimal(10, 2), PRICE)
            .input('STOCK', sql.Int, STOCK)
            .query(`
        INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK)
        OUTPUT INSERTED.*
        VALUES (@PRODUCTNAME, @PRICE, @STOCK)
      `);
        return result.recordset[0];
    },

    async update(id, { PRODUCTNAME, PRICE, STOCK }) {
        const pool = await getPool();
        const result = await pool.request()
            .input('id', sql.Int, id)
            .input('PRODUCTNAME', sql.NVarChar(100), PRODUCTNAME)
            .input('PRICE', sql.Decimal(10, 2), PRICE)
            .input('STOCK', sql.Int, STOCK)
            .query(`
        UPDATE PRODUCTS
        SET PRODUCTNAME = @PRODUCTNAME, PRICE = @PRICE, STOCK = @STOCK
        OUTPUT INSERTED.*
        WHERE PRODUCTID = @id
      `);
        return result.recordset[0];
    },

    async delete(id) {
        const pool = await getPool();
        const result = await pool.request()
            .input('id', sql.Int, id)
            .query('DELETE FROM PRODUCTS WHERE PRODUCTID = @id');
        return result.rowsAffected[0] > 0;
    }
};
