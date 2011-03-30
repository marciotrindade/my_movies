class User < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :validatable and :timeoutable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable

  # ASSOCIATIONS
  has_and_belongs_to_many :roles

  # VALIDATIONS
  validates_presence_of :name, :email, :username

  default_scope order(:name)

  def rights
    Right.joins({:roles => :users}).where("roles_users.user_id = ?", id).group('rights.id')
  end

  def has_access_to?(action)
    rights.map(&:action).include?(action)
  end

  memoize :rights

end
