require 'csv'
require 'open-uri'
require 'iconv'

class Admin::StatsController < Admin::BaseController
  def show
    def get_data_visit
      @visit_data = Visit.group_by_day(:started_at).count
      @csv_string = CSV.generate do |csv|
        csv << @visit_data.to_a.each {|elem| csv << elem}
      end
    send_data Iconv.conv('iso-8859-1//IGNORE', 'utf-8', @csv_string), filename: "something.csv"
    end
    
    @event_types = Ahoy::Event.group(:name).count

    @visits    = Visit.count
    @debates   = Debate.with_hidden.count
    @proposals = Proposal.with_hidden.count
    @comments  = Comment.not_valuations.with_hidden.count

    @debate_votes   = Vote.where(votable_type: 'Debate').count
    @proposal_votes = Vote.where(votable_type: 'Proposal').count
    @comment_votes  = Vote.where(votable_type: 'Comment').count
    @votes = Vote.count

    @user_level_two   = User.active.level_two_verified.count
    @user_level_three = User.active.level_three_verified.count
    @verified_users   = User.active.level_two_or_three_verified.count
    @unverified_users = User.active.unverified.count
    @users = User.active.count

    @user_ids_who_voted_proposals = ActsAsVotable::Vote.where(votable_type: 'Proposal')
                                                       .distinct
                                                       .count(:voter_id)

    @user_ids_who_didnt_vote_proposals = @verified_users - @user_ids_who_voted_proposals

    @spending_proposals = SpendingProposal.count
    budgets_ids = Budget.where.not(phase: 'finished').pluck(:id)
    @budgets = budgets_ids.size
    @investments = Budget::Investment.where(budget_id: budgets_ids).count
  end

  def proposal_notifications
    @proposal_notifications = ProposalNotification.all
    @proposals_with_notifications = @proposal_notifications.select(:proposal_id).distinct.count
  end

  def direct_messages
    @direct_messages = DirectMessage.count
    @users_who_have_sent_message = DirectMessage.select(:sender_id).distinct.count
  end

  def polls
    @polls = ::Poll.current
    @participants = ::Poll::Voter.where(poll: @polls)
  end
end
