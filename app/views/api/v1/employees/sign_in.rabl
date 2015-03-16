node :token do
  @token
end

node :employee do
  partial('base', object: @employee)
end
