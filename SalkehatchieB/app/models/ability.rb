class Ability
  include CanCan::Ability

  def initialize(user)

    #IMPORTANT: Abilities further down will override a previous one. For example, if we have a can :manage, Camp
    #then a cannot :destroy, Camp, the user will be able to do anything except destroy the camp.


    if user.is_admin?
      can :manage, :all

      can :manage, Camp

      #can update camp assignments for all applicants
      #can :update, CampAssignment
      can :manage, CampAssignment
      can :manage, CampRequest

      #cannot assign camper unless payment has been made
      #cannot :update, User, User.includes(:payments).where()

      #cannot assign camper 18+ if they haven't passed background check; temporary
      #this will need to be in the controller
      #cannot :update, User, User.where(:background_check => false && :date_of_birth > 1/1/1995)

      #can assign camp directors

      #can print all campers, organized by camp, with contact information

      #can print all campers not assigned to a camp with 1st, 2nd, & 34d choices + contact info

      #can print all campers who haven't paid + their contact info

      #can print list of campers over 18 not flagged as passing background checks + their contact info

      #can print total number of adults (18+) and youth by camp, as well as total

    end

    if user.is_camp_director?
      #can update site assignments for their camp
      can :manage, CampAssignment 
      #can :update, Site, current_user.camp_id =>
      can :read, Camp
      can :read, User

      #can edit camper information for their camp only

      #can print health information on all campers from that camp, organized by site
      can :print_health_info, Camp

      #print camp/site roster listings including name, church, age, gender, cell phone #
      can :roster_listing, Camp

      #can edit/update daily schedule for their camp only
      can :update, Schedule #, Schedule.where(:camp_id => user.current_camp_assignment.id)
      #can :manage, ReferenceForm
    end

    if user.is_site_leader?
      #can view and print all camper information for their camp/site combination
      #can :read, Site, Site.where(:site => user.site)

      #can edit/update daily schedule information for their camp/site combination only
      #Need primary key for camps and stuff
      #can :update, Schedule, Schedule.where(:camp => user.camp)
      #can :read, Camp, Camp.where(:camp => user.camp)
    end

    if user.is_parent?
      #can view photos from their child's camp only
      #can :read, Photo, Photo.where(:site => user.site)
    end

    if user.is_camper?
      #can view daily schedule from their site only
      #can :read, Schedule, Schedule.where(:site => user.site)

      #can upload pictures, videos, and their blog entries for their site only
      #can :read, Photo, Photo.where(:site => user.site)
      #can :read, Camp
      can :read, Camp
      #can :read, Payment, Payment.where(:user => user)
      can :create, Payment
      can [:read, :update, :destroy, :create], [CovenantForm, MedicalForm, ReferenceForm, CampRequest], :user_id => user.id

      #don't want this user to be able to view index page
      cannot :read, User
      can :manage, User, id: user.id 

      #can :manage, ReferenceForm, ReferenceForm.where(:user => user)
    end

  end

end