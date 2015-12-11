class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
    render layout: true
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end
   def postTransactionApi
      @bank = Bank.find_by( :token => params[:token])
      respond_to do |format|
      if    @bank
        if  @bank.token == params[:token]
   
          @transaction = Transaction.new(transaction_params)
          if @transaction.save
            @postTransactionOutput = OpenStruct.new(:transactions => @transaction , :status => 200 ,:message => "TRANSACTION WAS SAVED CREATED")
            format.json { render json: @postTransactionOutput  , status: :unprocessable_entity }
          end
         end  

          else
            @postTransactionError = OpenStruct.new(:status => 402, :message => "TRANSACTION FAILED")
            format.json { render json: @postTransactionError , status: :unprocessable_entity }
          end
        end

  end
      

  #    def postTransactionApi
  #     bank = Bank.find_by( :token => params[:token])
  #     if    bank != nil && params[:token] != nil
  #       if  bank.token == params[:token]
  #           citizen=CitizenBankDatum.find_by(national_id: params[:national_id])
  #           transaction = Transaction.new(transaction_params)
  #           transaction.bank_id = bank.id
  #        if citizen != nil
  #           transaction.citizen_id = citizen.citizen_id
  #         if transaction.save
  #           @postTransactionOutput = OpenStruct.new(:transactions => transaction , :status => 200 ,:message => "TRANSACTION WAS SAVED ")
  #           render json: @postTransactionOutput  
            
  #       end
      
  #        end  

  #         else
  #           @postTransactionError = OpenStruct.new(:status => 402, :message => "TRANSACTION FAILED token issues ")
  #           render json: @postTransactionError 
  #         end
     
  # end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:transaction_name, :transaction_amount, :account_balance, :bank_id, :citizen_id ,:national_id)
    end
end


