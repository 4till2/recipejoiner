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
    render turbo_stream: turbo_stream.replace('subscription_button', partial: 'shared/subscription_button',
                                              locals: { subscribable_id: params[:subscribable_id],
                                                        subscribable_type: params[:subscribable_type],
                                                        is_subscribed: sub.present? })
  end

  def paginated
    pagy, items = pagy(current_user.paginated_collection(params[:source]).distinct, items: params[:limit] || 10)
    render partial: 'shared/collection',
           locals: { items: items,
                     pagy: pagy,
                     link: params[:link]
           }

  end

  private

  def subscription
    Subscriptions.find_by(subscribable_id: params[:subscribable_id],
                          subscribable_type: params[:subscribable_type],
                          subscriber: current_user)
  end

end
