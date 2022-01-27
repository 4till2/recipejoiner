class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def update
    sub = current_user.subscribe_or_unsubscribe(params[:subscribable_id], params[:subscribable_type])
    render partial: 'shared/subscription_button',
           locals: { subscribable_id: params[:subscribable_id],
                     subscribable_type: params[:subscribable_type],
                     is_subscribed: sub.present? }
  end

  def show
    sub = subscription
    # render partial: 'shared/subscription_button',
    #        locals: { subscribable_id: params[:subscribable_id],
    #                  subscribable_type: params[:subscribable_type],
    #                  is_subscribed: sub.present? }
    render turbo_stream: turbo_stream.replace('subscription_button', partial: 'shared/subscription_button',
                                                                     locals: { subscribable_id: params[:subscribable_id],
                                                                               subscribable_type: params[:subscribable_type],
                                                                               is_subscribed: sub.present? })
  end

  private

  def subscription
    Subscriptions.find_by(subscribable_id: params[:subscribable_id],
                          subscribable_type: params[:subscribable_type],
                          subscriber: current_user)
  end
end
