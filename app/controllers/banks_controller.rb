  class BanksController < ApplicationController
  before_action :set_bank, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_bank!, except: [:display, :getTransactions, :getCustomers]
  
  # GET /banks
  # GET /banks.json
  def index
  # @banks = Bank.all
    render layout: true, action: :show
  end
  
  # GET /banks/1
  # GET /banks/1.json
  def show
    puts @current_Bank.methods
    if @bank.id != params[:id]
      puts "***************************"
         render action: :show, id: @bank.id
    end
  @number_of_customers = @bank.citizen_bank_data.select(:national_id).map(&:national_id).uniq.count
  @number_of_accounts = @bank.citizen_bank_data.count
  @number_of_transactions = @bank.transactions.count   
  end
  
  #displays the different banks in the db
  def display
    @banks = Bank.all
    render :template => "banks/index", layout: true
  end
  
  #method to get the transactions using the bank_id param passed
  def getTransactions
    @bank_id = params[:bank]
    if Transaction.find_by(bank_id: @bank_id).present?
      @transaction = Transaction.find_by(bank_id: @bank_id)
      @citizen_id = @transaction.citizen_id
      @citizen_name = Citizen.find(@citizen_id).name
      @citizen_national_id = Citizen.find(@citizen_id).national_id
    else
      @empty = "No transactions for this bank"
    end
    render layout: true, action: :showTransactions
  end
  
  def showTransactions
  end
  
  def getCustomers
    @bank_id = params[:bank]
    if CitizenBankDatum.find_by(bank_id: @bank_id).present?
      @citizen_bank = CitizenBankDatum.find_by(bank_id: @bank_id)
      @citizen = @citizen_bank.citizen
      @citizen_name = @citizen.name
      @citizen_number = @citizen.phone_num
      @citizen_email = @citizen.email
      @citizen_address = @citizen.address
      @citizen_national_id = @citizen.national_id
    else
      @empty = "No customers for this bank"
    end
    render layout: true, action: :showCustomers
  end
  # GET /banks/new
  def new
    @bank = Bank.new
  end
  
  # GET /banks/1/edit
  def edit
  end
  
  # POST /banks
  # POST /banks.json
  def create
    @bank = Bank.new(bank_params)
  
    respond_to do |format|
      if @bank.save
        format.html { redirect_to @bank, notice: 'Bank was successfully created.' }
        format.json { render :show, status: :created, location: @bank }
      else
        format.html { render :new }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /banks/1
  # PATCH/PUT /banks/1.json
  def update
    respond_to do |format|
      if @bank.update(bank_params)
        format.html { redirect_to @bank, notice: 'Bank was successfully updated.' }
        format.json { render :show, status: :ok, location: @bank }
      else
        format.html { render :edit }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /banks/1
  # DELETE /banks/1.json
  def destroy
    @bank.destroy
    respond_to do |format|
      format.html { redirect_to banks_url, notice: 'Bank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  #get all transactions related to a bank
  #get getTransaction
    def getTransactionApi
  #fetch data pertaining to that bank
      bank = Bank.find_by(:token => params[:token])
      respond_to do |format|
        if  bank
          if  bank.token == params[:token]
            #bank=banks.where(:token =>"32147").limit(20)
            @transactions = OpenStruct.new( :transactions => bank.transactions ,:status => 200 ,:message =>"REQUEST SUCCESSFUL")
            format.json { render json: @transactions }
          end
        else
          @getTransactionError = OpenStruct.new(:status => 402, :message => "ACCESS DENIED")
          format.json { render json: @getTransactionError , status: :unprocessable_entity }
        end
  
      end
    end
  #post transactions to the transaction log
  #post postTransaction
  
  
    def genToken
  #fetch data pertaining to that bank
      @bank = Bank.find_by(:token => params[:token])
      respond_to do |format|
        if @bank
          if @bank.token == params[:token]
            @bank.token = SecureRandom.hex
            if @bank.save
              @output = OpenStruct.new( :newToken => @bank.token  ,:status => 200 ,:message =>"REQUEST SUCCESSFUL")
              format.json { render json: @output }
            end
          end
        else
          @getTransactionError = OpenStruct.new(:status => 402, :message => "ACCESS DENIED")
          format.json { render json: @getTransactionError , status: :unprocessable_entity }
        end
      end
    end
   
  
    def signup_requests      
    end
  
    private
  
  # Use callbacks to share common setup or constraints between actions.
    def set_bank
      @bank = Bank.find(params[:id])
    end
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def bank_params
      params.require(:bank).permit(:name, :bank_type, :registration_no, :founded_data, :main_service, :bank_email, :bank_website, :bank_logo_url, :token)
    end
 end