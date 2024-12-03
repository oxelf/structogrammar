import { configureStore } from '@reduxjs/toolkit';
import counterReducer from './counter-slice';
import selectReducer from './selected-node-slice';
import windowReducer from './windows-slice';
import structogramReducer from './structogram-slice';
import codeLanguageReducer from './language-slice';
import codeReducer from './code-slice';
import {useDispatch, useSelector} from "react-redux"; // Import the reducer

const forceUpdateMiddleware = (storeAPI: any) => (next: any) => (action: any) => {
    if (action.type === 'setNode') {
        // Force Redux to consider the state as changed
        const result = next(action);
        storeAPI.dispatch({ type: 'FORCE_UPDATE' });
        return result;
    }
    return next(action);
};

// Configure the store
export const store = configureStore({
    reducer: {
        selectedNode: selectReducer,
        counter: counterReducer, // Add the reducer here
        structograms: structogramReducer,
        windows: windowReducer,
        codeLanguage: codeLanguageReducer,
        code: codeReducer,
    },
    middleware: (getDefaultMiddleware) =>
        getDefaultMiddleware({
            serializableCheck: false, // Disable the serializable check middleware
        }).concat(forceUpdateMiddleware),
});

// Export types for state and dispatch
export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

export const useAppDispatch = useDispatch.withTypes<AppDispatch>()
export const useAppSelector = useSelector.withTypes<RootState>()