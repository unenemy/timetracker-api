node :token do
  @token
end

node :manager do
  partial('base', object: @manager)
end
