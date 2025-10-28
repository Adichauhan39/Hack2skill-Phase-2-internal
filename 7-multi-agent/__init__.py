"""
7-multi-agent package initialization
Exports the main root_agent for the travel booking system
"""

from .manager import agent
from .manager.agent import root_agent

__all__ = ['agent', 'root_agent']
