class RecipesController < ApplicationController

    def index
        if session[:user_id]
            recipes = User.find_by(id: session[:user_id]).recipes
            render json: recipes, include: :user, status: :created
        else
            render json: { errors: ["Unauthorized"] }, status: :unauthorized
        end
    end

    def create
        if session[:user_id]
            user = User.find_by(id: session[:user_id])
            recipe = user.recipes.new(recipe_params)
            if recipe.save
                # recipe.save
                # user.recipes << recipe
                render json: recipe, include: :user, status: :created
            else
                render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
            end
        else
            render json: { errors: ["Unauthorized"] }, status: :unauthorized
        end
    end

    private
    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end
end
