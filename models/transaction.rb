require_relative('../db/sql_runner')

class Transaction

  attr_accessor :transaction_timestamp, :amount, :merchant_id, :tag_id
  attr_reader :id

  def initialize(options)
    @transaction_timestamp = options['transaction_timestamp']
    @amount = options['amount']
    @merchant_id = options['merchant_id'].to_i
    @tag_id = options['tag_id'].to_i

    @id = options['id'].to_i if options['id']
  end

  def save()
    sql = "INSERT INTO transactions
    (
      transaction_timestamp, amount, merchant_id, tag_id
    )VALUES(
      $1, $2, $3, $4
    )
    RETURNING id
    "
    values = [@transaction_timestamp, @amount, @merchant_id, @tag_id]
    @id = SqlRunner.run(sql, values).first()['id'].to_i
  end

  def update()
    sql = "UPDATE transactions SET
    (
      transaction_timestamp, amount, merchant_id, tag_id
    )=(
      $1, $2, $3, $4
    )
    WHERE id = $5
    "
    values = [@transaction_timestamp, @amount, @merchant_id, @tag_id, @id]
    SqlRunner.run(sql, values)
  end

  def Transaction.delete_all()
    sql = "DELETE FROM transactions"
    SqlRunner.run(sql)
  end


  def Transaction.all()
    sql = "SELECT * FROM transactions"
    transactions = SqlRunner.run(sql)
    return transactions.map {|tran| Transaction.new(tran)}
  end


end #class end
