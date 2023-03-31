# frozen_string_literal: true

Rails.application.routes.draw do
  root to: proc { |_env| [200, {}, ['OK']] }

  get 'rates', to: 'rates#index'
  post 'rates', to: 'rates#index'
end
